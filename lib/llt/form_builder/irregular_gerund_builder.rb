module LLT
  class IrregularGerundBuilder < GerundBuilder
    form_class :gerund
    look_up :stem, :thematic
    uses_endings_of :gerund
  end
end
