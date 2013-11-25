module LLT
  class Form
    class VerbalNoun < Form

      extend Helpers::QueryMethods

      add_query_methods_for(:modus)

      def init_keys
        super + %i{ stem thematic extension sexus casus numerus ending modus tempus genus prefix }
      end

      def segments
        [@prefix, @stem, @thematic, @extension, @ending]
      end
    end
  end
end
