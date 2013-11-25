module LLT
  class Form
    class Noun < Declinable
      def init_keys
        super + %i{ persona place }
      end

      def segmentized
        unless @ending.empty?
          super
        else
          @string
        end
      end
    end
  end
end
