module LLT
  class IrregularPpaBuilder < PpaBuilder
    form_class :ppa
    look_up :stem, :thematic
    uses_endings_of :ppa
  end
end
