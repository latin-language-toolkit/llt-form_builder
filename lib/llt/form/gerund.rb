module LLT
  class Form
    class Gerund < VerbalNoun
      def init_functions
        super + %i{ substantive }
      end
    end
  end
end
