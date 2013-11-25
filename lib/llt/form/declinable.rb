module LLT
  class Form
    class Declinable < Form
      require 'llt/form/noun'
      require 'llt/form/adjective'
      require 'llt/form/ethnic'

      extend Helpers::QueryMethods

      def init_keys
        super + %i{ stem ending sexus casus numerus }
      end

      def init_functions
        super + %i{ substantive }
      end

      def segments
        [@stem, @ending]
      end
    end
  end
end
