module LLT
  class PerfectumBuilder < VerbBuilder
    look_up :thematic, :extension # investigate why this is needed an not handled through inheritance

    def indices
      { persona: persona_index,
        numerus: [0, 3],
        genus: [0],
        modus: [0, 6],
        tempus: [nil, nil, nil, 0, 12, 24],
      }
    end
  end
end
