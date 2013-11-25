module LLT
  class DeclinableBuilder < FormBuilder
    attr_reader :sexus, :comparatio

    def initialize(stem)
      super
      @irregular_forms = extended_special_forms(irregulars_with_nominative(stem))
      @additional_forms = extended_special_forms(stem[:additional_forms])
    end

    def compute
      with_replacements(regular_forms) + additional_forms
    end

    def indices
      { casus:   [0, 1, 2, 3, 4, 5],
        numerus: [0, 6],
        sexus:   [0, 12, 24] }
    end

    def index_of_ending(casus, numerus, sexus = nil)
      casus + (numerus == 1 ? -1 : 5)
    end
    alias :ioe :index_of_ending

    def casus_numerus_sexus_by_index(index, sexus = @sexus)
      # superflous method - could be solved through
      # attributes_by_index, however this is noticably faster and thus stays

      if index < 6
        [index + 1, 1, sexus]
      else
        [index - 5, 2, sexus]
      end
    end

    def regular_forms
      endings.each_with_index.map do |ending, i|
        next unless @lookup_indices.include?(i)
        new_form_through_index(ending, i)
      end.compact # compact because of next steps
    end

    def new_form_through_index(ending, i)
      casus, numerus, sexus = casus_numerus_sexus_by_index(i)
      ending = ending.to_s
      new_form(ending: ending, casus: casus, numerus: numerus, sexus: sexus, index: i)
    end

    def extended_special_forms(specials)
      specials = specials || []
      specials + specials.each_with_object([]) do |(string, *attr), arr|
        new_attributes(*attr).each { |new_attr| arr << [string,  *new_attr] }
      end
    end

    def irregulars_with_nominative(stem)
      i = if @nom
            irreg = nominatives
            if irregs = stem[:irregular_forms]
              irregs + irreg
            else
              irreg
            end
          else
            stem[:irregular_forms] || []
          end

      i + proper_vocative
    end

    def new_attributes(*attrs)
      casus, numerus, sexus = *attrs
      sexus = sexus || @sexus
      new_attrs = []

      if ioe(casus, numerus) == 0
        new_attrs << [5, 1, sexus] unless regular_o_declension? || pronominal_declension?
        if sexus == :n
          new_attrs << [4, 1, sexus]
        end
      end

      new_attrs
    end

    def proper_vocative
      o_declension_on_ius? ? [[@stem, 5, 1]] : []
    end

    def regular_o_declension?
      @inflection_class == 2 && @nom.to_s =~ /us$/ # to_s because it might be nil
    end

    def pronominal_declension?
    end

    def o_declension_on_ius?
      @inflection_class == 2 && @stem.end_with?("i") && @sexus == :m # is there a neutrum like that?
    end

    def additional_forms
      @additional_forms.map do |string, *attrs|
        casus, numerus, sexus = *attrs
        i = ioe(casus, numerus, sexus)
        if @lookup_indices.include?(i)
          new_special_form(string: string, casus: casus, numerus: numerus, sexus: sexus, index: i)
        end
      end.compact
    end

    def with_replacements(regular_forms)
      @irregular_forms.each do |string, *attrs|
        casus, numerus, sexus = *attrs
        i = ioe(casus, numerus, sexus)
        if @lookup_indices.include?(i)
          next unless ri = regular_forms.find_index { |f| f.index == i }
          regular_forms[ri] = new_special_form(string: string, casus: casus, numerus: numerus, sexus: sexus, index: i)
        end
      end
      regular_forms
    end

    def new_special_form(args)
      args = args.merge(default_args)
      string = args[:string]
      i = index_of_ending(args[:casus], args[:numerus], args[:sexus])
      ending = special_ending(string, i).to_s
      form_class.new(args.merge(stem: string.chomp(ending), ending: ending))
    end

    def special_ending(word, index)
      endings_path.constants.each do |const|
        ending = endings_path.const_get(const)[index]
        return ending if word.end_with?(ending.to_s)
      end
      nil
    end

    def er_nominative_possible?
      # only Noun and Adjective override this, as they can have a nominative on er.
      # other Declinables like Gerundives don't need this
      false
    end

    # this is a slight hack to handle O Declension on er.
    # the Endings constants for noun has US at its first position,
    # this guarantees a match even when the ending is empty (which means that the passsed along
    # nominative value shall be used.
    # similar conditions will need to be written for A decl on as.
    def endings_lookup(ending, x)
      if ending.empty?
        if er_nominative_possible?
          # not sure if this needs further safeties - asking explicitly for er?
          # well it does! 2013-10-08 - fili!
          return x.to_s =~ /^(us|e)$/
        elsif o_declension_on_ius?
          return x.to_s =~ /^e$/
        end
      end
      super
    end
  end
end
