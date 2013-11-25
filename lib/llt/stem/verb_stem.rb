module LLT
  class Stem
    class VerbStem < Stem
      def init_keys
        %i{ stem inflection_class deponens pf_composition }
      end

      def to_s
        "#{@type}#{@inflection_class}#{dep_state.magenta} #{@stem}"
      end

      private
      def dep_state
        @deponens ? " dep" : ""
      end
    end
  end
end
