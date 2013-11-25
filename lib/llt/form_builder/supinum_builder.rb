module LLT
  class SupinumBuilder < DeclinableBuilder
    builds_with :modus
    has_modus t.supinum

    def index_of_ending(casus, numerus, sexus = nil)
      case casus
      when 3 then 0
      when 4 then 1
      when 6 then 2
      end
    end
    alias :ioe :index_of_ending

    def casus_numerus_sexus_by_index(index, sexus = nil)
      case index
      when  0 then [3, 1, :n]
      when  1 then [4, 1, :n]
      when  2 then [6, 1, :n]
      end
    end
  end
end
