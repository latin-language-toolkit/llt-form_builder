module LLT
  class GerundBuilder < DeclinableBuilder
    builds_with :modus, :extension, :prefix

    has_extension "nd"
    has_modus t.gerundium

    look_up :thematic

    validate :extension

    def indices
      { casus:   [nil, 0, 1, 2, nil, 3],
        numerus: [0],
        sexus:   [0] }
    end

    def index_of_ending(casus, numerus, sexus = nil)
      case casus
      when  2 then 0
      when  3 then 1
      when  4 then 2
      when  6 then 3
      end
    end
    alias :ioe :index_of_ending

    def casus_numerus_sexus_by_index(index, sexus = nil)
      case index
      when 0 then [2, 1, :n]
      when 1 then [3, 1, :n]
      when 2 then [4, 1, :n]
      when 3 then [6, 1, :n]
      end
    end
  end
end
