module LLT
  class EthnicBuilder < DeclinableBuilder
    builds_like_an :adjective
    uses_endings_of :adjective

    endings_defined_through :inflection_class, :number_of_endings

    def initialize(stem)
      @number_of_endings = (stem[:inflection_class] == 1 ? 3 : 2)
      super
    end

    def stays_capitalized
      true
    end
  end
end
