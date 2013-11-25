module LLT
  class Form
    class PersonalPronoun < Form
      def init_keys
        %i{ stem inflection_class casus numerus suffix index }
      end

      def segments
        [@stem, @suffix]
      end
    end
  end
end
