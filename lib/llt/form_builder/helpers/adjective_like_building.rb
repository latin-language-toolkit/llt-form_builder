module LLT
  class FormBuilder
    module AdjectiveLikeBuilding
      def casus_numerus_sexus_by_index(i, sexus = nil)
        # superflous method - code be solved through attributes_by_index,
        # however this is noticably faster and thus stays

        mod, sexus = case i
                     when  0..11 then [ 0, :m]
                     when 12..23 then [12, :f]
                     else             [24, :n]
                     end
        i -= mod

        super(i, sexus)
      end

      def index_of_ending(casus, numerus, sexus = nil)
        i = super
        case sexus
        when :f then i + 12
        when :n then i + 24
        else i
        end
      end
      alias :ioe :index_of_ending
    end
  end
end
