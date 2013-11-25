require 'llt/helpers/roman_numerals'

module LLT
  class Form
    class Cardinal < Form
      def initialize(args)
        extract_args!(args)
      end

      def init_keys
        %i{ roman decimal string casus sexus }
      end

      def arabic
        @decimal
      end

      def to_roman
        @roman || Helpers::RomanNumerals.to_roman(@decimal)
      end

      def to_decimal
        @decimal || Helpers::RomanNumerals.to_decimal(@roman)
      end

      def to_s
        @roman || @string
      end
    end
  end
end
