module LLT
  class Stem
    class NounStem < Stem
      attr_reader :nom

      def init_keys
        %i{ nom stem inflection_class sexus persona place }
      end

      def to_s
        "#{t.send(@type, :abbr)}#{@inflection_class} #{@stem}"
      end

      def nominative
        @nom
      end

      def third_decl_with_possible_ne_abl?
        if @inflection_class == 3
          @nom.match(/[id]?on?$/) && @stem.match(/d?in$|i?on$/) ||
          @nom.match(/men$/) && @stem.match(/min$/)
        end
      end
    end
  end
end
