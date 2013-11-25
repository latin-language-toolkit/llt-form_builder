module LLT
  class PersonalPronounBuilder < DeclinableBuilder
    endings_defined_through :inflection_class

    validate :suffix

    def indices
      {
        casus: [0, 1, 2, 3, nil, 5],
        numerus: [0, 6],
      }
    end

    def compute
      (regular_forms + forms_with_suffix + additional_genetives).sort_by(&:index)
    end

    def forms
      endings
    end

    def forms_with_suffix
      suffixeds = SUFFIXED_FORMS[@inflection_class]
      res = []
      return res unless suffixeds
      suffixeds.each do |i, suffixes|
        if @lookup_indices.include?(i)
          suffixes.each do |suffix|
            f = forms[i]
            res << new_form_through_index(f, i, suffix)
          end
        end
      end
      res.flatten.compact
    end

    def additional_genetives
      if nos_or_vos && @lookup_indices.include?(7) # gen.pl
        [new_form_through_index("#{@inflection_class}trum", 7)]
      else
        []
      end
    end

    def nos_or_vos
      @inflection_class == :nos || @inflection_class == :vos
    end

    def new_form_through_index(form, i, suffix = "")
      # nil values in ending == form present, vocatives f.e., or se in nom.
      return unless form
      c, n = casus_numerus_sexus_by_index(i)
      new_form(stem: form, casus: c, numerus: n, suffix: suffix, index: i)
    end

    def default_args
      # need to override, because we want to use our custom "stem", which is actually the form itself
      { inflection_class: @inflection_class }
    end


    private

    def self.compute_suffixed_forms
      hash = container
      # arrays are styled as casus, numerus, suffix
      # 0: cum, 1: met, 2: te, 3: se
      suffixes = %w{ cum met te se }
      # -cum
      hash[:ego] << [6,1,0]
      hash[:tu] << [6,1,0]
      hash[:se] << [6,1,0] << [6,2,0]
      hash[:nos] << [6,2,0]
      hash[:vos] << [6,2,0]
      # -met
      hash[:ego] << [1,1,1] << [2,1,1] << [3,1,1] << [4,1,1] << [6,1,1]
      hash[:nos] << [1,2,1] << [3,2,1] << [4,2,1] << [6,2,1]
      hash[:vos] << [1,2,1] << [3,2,1] << [4,2,1] << [6,2,1]
      hash[:tu] << [3,1,1]
      # -te
      hash[:tu] << [1,1,2] << [4,1,2] << [6,1,2]
      # -se
      hash[:se] << [4,1,3] << [6,1,3] << [4,2,3] << [6,2,3]


      res = {}
      hash.each do |key, values|
        h = container
        values.each do |casus, numerus, suffix|
          h[ioe(casus, numerus)] << suffixes[suffix]
        end
        res[key] = h
      end
      res
    end

    def self.ioe(casus, numerus)
      casus + (numerus == 1 ? -1 : 5)
    end

    def self.container
      Hash.new { |h, k| h[k] = [] }
    end

    SUFFIXED_FORMS = compute_suffixed_forms
  end
end
