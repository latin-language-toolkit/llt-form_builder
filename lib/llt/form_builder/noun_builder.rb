module LLT
  class NounBuilder < DeclinableBuilder
    builds_with :sexus, :persona, :place
    endings_defined_through :inflection_class, :sexus

    attr_reader :persona, :place

    def init_keys
      super + %i{ persona place }
    end

    def stays_capitalized
      @persona || @place
    end

    def nominatives
      [[@nom, 1, 1]]
    end

    def er_nominative_possible?
      @inflection_class == 2 && ! o_declension_on_ius? # fili has no ending as well!
    end
  end
end
