module LLT
  class Form
    class Participle < VerbalNoun
      def init_functions
        super + %i{ substantive adjective participle }
      end
    end
  end
end
