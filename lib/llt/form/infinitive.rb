module LLT
  class Form
    class Infinitive < Form
      def init_keys
        super + %i{ stem tempus genus modus thematic ending prefix }
      end

      def segments
        [@prefix, @stem, @thematic, @ending]
      end
    end
  end
end
