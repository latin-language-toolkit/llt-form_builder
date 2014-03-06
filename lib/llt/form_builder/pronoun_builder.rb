module LLT
  class PronounBuilder < DeclinableBuilder
    builds_like_an :adjective
    lookup_class PronounSegments
    look_up :stem, :particle, :prefixed_particle

    endings_defined_through :inflection_class

    validate :suffix # quibuscum etc.

    def indices
      { casus:   [0, 1, 2, 3, nil, 5],
        numerus: [0, 6],
        sexus:   [0, 12, 24] }
    end

    def compute
      # sort by index and the string length, so that quibus is one position
      # in front of quibuscum
      (regular_forms + forms_with_suffix).sort_by { |f| [f.index, f.to_s.size ]}
    end

    def init_keys
      %i{ type inflection_class }
    end

    def default_args
      { inflection_class: @inflection_class }
    end

    def endings_lookup(ending, x)
      if ending == "s" && is_or_idem
        x.to_s =~ /^i?s$/
      elsif ending == "ic"
        x.to_s == "id"
      else
        super
      end
    end
                         #quo quibus qua quibus quo quibus
    INDICES_OF_CUM_WITH_QUI = [5, 11, 17, 23, 29, 35]
    def forms_with_suffix
      if @inflection_class == :qui
        indices = INDICES_OF_CUM_WITH_QUI & @lookup_indices
        indices.map { |i| [endings[i], i] }.map do |ending, i|
          casus, numerus, sexus = casus_numerus_sexus_by_index(i)
          ending = ending.to_s
          new_form(ending: ending, casus: casus, numerus: numerus, sexus: sexus, index: i, suffix: "cum")
        end.compact # for forms that don't make it through validation
      else
        []
      end
    end

    def corrections(args)
      if @options[:ending] == "ic"
        keep_given_value(args, :ending)
      end

      super
    end

    # Allows i and e stem for specific forms like ii/ei.
    # If such a form is detected return the validation,
    # in every other case use the default rule.
    def validation_rule(args, validator)
      if is_or_idem
        case validator
        when :stem
          c, n, s = %i{ casus numerus sexus }.map { |k| args[k] }

          if n == 2 && ((c == 1 && s == :m) || (c == 3 || c == 6))
            val_values = [args[validator], @options[validator]]
            if val_values.all? { |stem| stem =~ /^[ei]$/ }
              keep_given_value(args, validator)
              # also keep the ending to catch is, iis and eis
              keep_given_value(args, :ending)
              return true # to prevent the super call
            end
          end
        end
      end

      super
    end

    def is_or_idem
      @inflection_class == :is || @inflection_class == :idem
    end

    pt = {
           demonstrative_pronoun: %i{ hic is idem iste ipse ille },
           relative_pronoun:      %i{ qui quicumque quisquis },
           indefinite_pronoun:    %i{ aliqui quilibet quivis quis aliquis
                                      quisquam quisque quisque_s quidam quinam
                                      unusquisque unusquisque_s uterque quispiam },
           interrogative_pronoun: %i{ uter }
         }

    PRON_TYPE = pt.each_with_object({}) do |(type, infl_classes), h|
      infl_classes.each { |infl_cl| h[infl_cl] = type }
    end

    def form_class
      constant_by_type(PRON_TYPE[@inflection_class], namespace: LLT::Form)
    end
  end
end
