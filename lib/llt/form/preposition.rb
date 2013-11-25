module LLT
  class Form
    class Preposition < Uninflectable
      def init_keys
        %i{ string takes_4th takes_6th }
      end

      def valency
        @valency ||= valencies
      end

      def needs?(arg)
        valency.include?(arg)
      end

      def valencies
        v = []
        v << 4 if @takes_4th
        v << 6 if @takes_6th
        v
      end

      def takes_4th?
        @takes_4th
      end

      def takes_6th?
        @takes_6th
      end
    end
  end
end
