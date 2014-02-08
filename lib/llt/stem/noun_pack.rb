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

      def third_decl_with_possible_ve_abl?
        super { @stems.any?(&:third_decl_with_possible_ve_abl?) }
      end

      def o_decl_with_possible_ne_voc?
        super { @stems.any?(&:o_decl_with_possible_ne_voc?) }
      end
    end
  end
end
