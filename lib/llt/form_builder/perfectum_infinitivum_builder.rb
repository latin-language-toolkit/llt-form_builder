module LLT
  class PerfectumInfinitivumBuilder < InfinitivumBuilder
    def indices
      super.merge(tempus: [nil, nil, nil, 0])
    end
  end
end
