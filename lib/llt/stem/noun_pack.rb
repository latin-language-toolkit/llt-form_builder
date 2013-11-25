module LLT
  class Stem
    class NounPack < Pack
      def initialize(*args)
        super(*args)
        @lemma = @stems.first.nominative
      end

      def third_decl_with_possible_ne_abl?
        super { @stems.any?(&:third_decl_with_possible_ne_abl?) }
      end
    end
  end
end
