module LLT
  class AdjectiveBuilder < DeclinableBuilder
    builds_like_an :adjective
    builds_with :comparatio

    validate :comparison_sign

    endings_defined_through :inflection_class, :number_of_endings, :comparatio

    def init_keys
      super + %i{ comparatio number_of_endings }
    end

    def nominatives
      res  = [[@nom, 1, 1, :m]]
      if @number_of_endings == 1 && @inflection_class == 3
        res += [[@nom, 1, 1, :f], [@nom, 1, 1, :n]]
      end
      res
    end

    def pronominal_declension?
      @inflection_class == 5 && @number_of_endings == 3
    end

    # having this not implemented separately in the adjective builder
    # led to problems with vocatives! The infl class for detecting O
    # is different here!
    def regular_o_declension?
      @inflection_class == 1 && @nom.to_s =~ /us$/ # to_s because it might be nil
    end

    def corrections(args)
      extract_comparison_sign(args)
    end

    def extract_comparison_sign(args)
      return if @comparatio == :positivus

      st = args[:stem]

      case @comparatio
      when :comparativus
        new_stem, new_comp_sign = comparativus_extraction(st, args)
      when :superlativus
        st.match(/(#{marker(:RIM)}|#{marker(:LIM)}|#{marker(:ISSIM)})$/)
        new_stem      = st.chomp($1)
        new_comp_sign = $1
      end

      args[:stem] = new_stem
      args[:comparison_sign] = new_comp_sign
    end

    def comparativus_extraction(stem, args)
      c = args[:casus]
      s = args[:sexus]
      n = args[:numerus]

      new_stem = stem.chomp(marker(:COMP_MF)) # do not use chomp! as other forms will get severed
      raise "No comparison sign for comparative present" if new_stem == stem
      [new_stem, comp_sign(c, s, n)]
    end

    def comp_sign(c, s, n)
      if s == :n && n == 1 && c.to_s.match(/^(1|4|5)$/)
        marker(:COMP_N)
      else
        marker(:COMP_MF)
      end
    end

    def markers_path
      path = constant_by_type(namespace: LLT::Constants::Markers)
      metrical? ? path::Metrical : path
    end

    def marker(const)
      markers_path.const_get(const)
    end

    def er_nominative_possible?
      @inflection_class == 1
    end
  end
end
