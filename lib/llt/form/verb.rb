module LLT
  class Form
    class Verb < Form
      def init_keys
        %i{ inflection_class stem thematic extension ending persona tempus modus genus numerus contraction prefix }
      end

      def init_functions
        f = super
        # if it has a name, it's an irregular verb
        f << @inflection_class if @inflection_class.is_a?(Symbol)
        f
      end

      def contracted?
        @contraction
      end

      def segments
        if @extension == "b"
          [@prefix, @stem, @extension, @thematic, @ending]
        else
          [@prefix, @stem, @thematic, @extension, @ending]
        end
      end
    end
  end
end
