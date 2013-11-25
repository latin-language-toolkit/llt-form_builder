module LLT
  class Form
    class Pronoun < Declinable
      def init_keys
        super + %i{ particle prefixed_particle suffix }
      end

      def init_functions
        super + [@inflection_class]
      end

      def segments
        [@prefixed_particle, @stem, @ending, @particle, @suffix]
      end
    end
  end
end
