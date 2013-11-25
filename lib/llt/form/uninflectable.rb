module LLT
  class Form
    class Uninflectable < Form
      def initialize(args)
        extract_args!(args)
      end

      def init_keys
        %i{ string }
      end

      def stem
        @string
      end
      alias_method :lemma, :stem

      def segments
        [@string]
      end
    end
  end
end
