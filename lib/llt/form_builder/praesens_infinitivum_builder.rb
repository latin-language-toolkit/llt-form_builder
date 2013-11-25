module LLT
  class PraesensInfinitivumBuilder < InfinitivumBuilder
    endings_defined_through :inflection_class

    def indices
      super.merge(tempus: [0])
    end
  end
end
