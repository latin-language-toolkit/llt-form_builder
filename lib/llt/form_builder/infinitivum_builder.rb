module LLT
  class InfinitivumBuilder < VerbBuilder
    builds_with :modus
    has_modus t.inf

    form_class :infinitive

    look_up :thematic

    def indices
      { genus: (@deponens ? [1] : [0,1]) }
    end

    def new_form_through_index(ending, i)
      g, t = attributes_by_index(i)
      new_form(ending: ending, genus: g, tempus: t, index: i)
    end
  end
end
