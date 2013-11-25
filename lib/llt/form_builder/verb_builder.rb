module LLT
  class VerbBuilder < FormBuilder
    builds_with :impersonalium, :contraction, :prefix

    form_class :verb

    look_up :thematic, :extension

    def persona_index
      @impersonalium ? [nil, nil, 2] : [0, 1, 2]
    end

    def genus_index
      @deponens ? [6] : [0, 6]
    end

    def regular_forms
      endings.each_with_index.map do |ending, i|
        next unless (@lookup_indices.include?(i) && ending) # nil values in verb endings are escaped
        new_form_through_index(ending, i)
      end.compact
    end

    def new_form_through_index(ending, i)
      p, n, g, m, t = attributes_by_index(i)
      new_form(ending: ending, persona: p, numerus: n, tempus: t, modus: m, genus: g, index: i)
    end

    def contraction
      @options[:contraction]
    end

    def endings_namespace
      super::Verb
    end
  end
end
