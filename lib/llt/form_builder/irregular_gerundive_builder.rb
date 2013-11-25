module LLT
  class IrregularGerundiveBuilder < GerundiveBuilder
    form_class :gerundive
    look_up :stem, :thematic
    uses_endings_of :gerundive
  end
end
