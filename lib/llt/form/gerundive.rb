module LLT
  class Form
    class Gerundive < VerbalNoun
      # Beware! The gerund is not really a substantive.
      # This is basically a hack to make a Gerundive dominant
      # by default.
      def init_functions
        super + %i{ substantive }
      end
    end
  end
end
