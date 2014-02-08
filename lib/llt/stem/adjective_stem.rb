module LLT
  class Stem
    class AdjectiveStem < Stem
      attr_reader :comparatio, :nom

      def init_keys
        %i{ nom stem inflection_class comparatio number_of_endings }
      end

      def to_s
        "#{t.send(@type, :abbr)}#{@inflection_class} #{@stem}"
      end

      def nominative
        @nom
      end

      def third_decl_with_possible_ne_abl?
        @inflection_class == 3 && @nom.match(/nis$/) && @stem.match(/n$/)
      end

      def o_decl_with_possible_ne_voc?
        @inflection_class == 1 && @nom.match(/nus$/)
      end
    end
  end
end
