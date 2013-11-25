module LLT
  class Form
    class Adjective < Declinable
      def init_keys
        super + %i{ comparatio number_of_endings comparison_sign }
      end

      def segmentized
        unless @ending.empty? && ! @comparatio
          super.chomp("-")
        end
      end

      def segments
        [@stem, @comparison_sign, @ending]
      end
    end
  end
end
