module LLT
  class PraesensBuilder < VerbBuilder
    endings_defined_through :inflection_class

    look_up :thematic, :extension

    def indices
      { persona: persona_index,
        numerus: [0, 3],
        genus:   genus_index,
        modus:   [0, 12, 24],
        tempus:  [0, 36, 72]
      }
    end

    def indices_by_ending(ending)
      indices = super
      if @deponens
        PASSIVE_INDICES & indices
      else
        indices
      end
    end


    def self.passive_indices
      # build all possible indices, slice them according to their genus, select only even ones,
      # i.e. the passive endings
      (0..107).each_slice(6).each_with_index.each_with_object([]) { |(e, i), r| r << e if i.odd? }.flatten
    end
    PASSIVE_INDICES = passive_indices

    def corrections(args)
      if args[:inflection_class] == 1
        if args[:tempus] == t.pr && (args[:modus] == t.con || args[:ending].match(/or?$/))
          args[:stem] = args[:stem].chop
        end
      end
    end
  end
end
