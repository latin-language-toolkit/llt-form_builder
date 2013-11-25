module LLT
  class FormBuilder
    class VerbSegments
      attr_reader :inflection_class, :modus

      include Helpers::Initialize
      include Helpers::Normalizer
      extend Helpers::Normalizer

      def self.get(method, args)
        c = if temp = args[:tempus]
              const_get("#{t.send(temp, :camelcase)}Segments")
            else
              PraesensSegments
            end
        c.new(args).send(method).to_s # to_s to capture all nil returns and give back an empty string
      end

      def initialize(args)
        extract_normalized_args!(args)
      end

      def init_keys
        %i{ sexus casus modus inflection_class numerus persona ending genus }
      end

      private

      #%w{ esse posse ferre ire velle nolle malle fieri edere }.each do |irreg|
      #  class_eval <<-STR
      #    def #{irreg}
      #      :#{irreg}
      #    end
      #  STR
      #end

      def a_or_e_conjugation
        @inflection_class == 1 || @inflection_class == 2
      end

      def c_or_m_conjugation
        @inflection_class == 3 || @inflection_class == 5
      end

      def first_sg
        @persona == 1 && @numerus == 1
      end

      def third_pl
        @persona == 3 && @numerus == 2
      end

      def special_thematic_for_i_conj
        if third_pl
          n(:THEMATIC_U)
        end
      end
      alias :thematic_indicativus_4 :special_thematic_for_i_conj

      def n(arg)
        LLT::Constants::Markers::Verb.const_get(arg)
      end

      def usual_thematic_vowels
        case @ending
        when /^[stm]/ then n(:THEMATIC_I)
        when /^r/     then n(:THEMATIC_E)
        when /^n/     then n(:THEMATIC_U)
        end
      end
      alias :thematic_indicativus_3 :usual_thematic_vowels

      def thematic
        send("thematic_" + modus_term)
      end

      def modus_term
        "#{t.send(@modus, :full)}"
      end

      def stem_of_fieri
        "fi"
      end

      def stem_of_malle
        "mal"
      end

      def stem_of_nolle
        "nol"
      end

      def stem_of_ferre
        "fer"
      end

      def stem
        send("stem_of_#{@inflection_class}")
      end

      class PraesensSegments < VerbSegments
        def extension
          arr = %i{ esse velle nolle malle edere posse }
          if @modus == t.coniunctivus
            case @inflection_class
            when 1
              n(:PRAESENS_CONIUNCTIVUS_A)
            when ->(x) { arr.include?(x) }
              n(:PRAESENS_CONIUNCTIVUS_IRREGULAR)
            else
              n(:PRAESENS_CONIUNCTIVUS)
            end
          end
        end

        def stem_of_edere
          case @modus
          when t.indicativus then indicativus_stem_of_edere
          when t.coniunctivus then "ed"
          when t.imperativus then "es"
          when t.infinitivum then "es"
          end
        end

        def indicativus_stem_of_edere
          case [@persona, @numerus]
          when [2, 1] then "es"
          when [3, 1] then "es"
          when [2, 2] then "es"
          else "ed"
          end

        end

        def stem_of_malle
          case @modus
          when t.indicativus  then indicativus_stem_of_malle
          when t.coniunctivus then "mal"
          when t.infinitivum  then "mal"
          end
        end

        def indicativus_stem_of_malle
          case [@persona, @numerus]
          when [2, 1] then "mavi"
          when [3, 1] then "mavul"
          when [2, 2] then "mavul"
          else "mal"
          end
        end

        def stem_of_velle
          case @modus
          when t.indicativus  then indicativus_stem_of_velle
          when t.coniunctivus then "vel"
          when t.infinitivum  then "vel"
          end
        end

        def indicativus_stem_of_velle
          case [@persona, @numerus]
          when [2, 1] then "vi"
          when [3, 1] then "vul"
          when [2, 2] then "vul"
          else "vol"
          end
        end

        def stem_of_ire
          case @modus
          when t.indicativus  then indicativus_stem_of_ire
          when t.coniunctivus then "e"
          when t.imperativus  then "i"
          when t.infinitivum  then "i"
          when t.gerundium    then "e"
          when t.gerundivum   then "e"
          when t.participium  then iens ? "i" : "e"
          end
        end

        def iens
          if @numerus == 1
            @casus == 1 || @casus == 5 || ( @casus == 4 && @sexus == :n )
          end
        end

        def indicativus_stem_of_ire
          if third_pl || @persona == 1 && @numerus == 1
            "e"
          else
            "i"
          end
        end

        def stem_of_esse
          case @modus
          when t.indicativus then
            if ( @numerus == 1 && @persona == 1 ) || ( @numerus == 2 && ( @persona == 1 || @persona == 3 ))
              n(:STEM_ESSE_S)
            else
              n(:STEM_ESSE_ES)
            end
          when t.coniunctivus then n(:STEM_ESSE_S)
          when t.imperativus  then n(:STEM_ESSE_ES)
          when t.infinitivum  then n(:STEM_ESSE_ES)
          when t.participium  then n(:STEM_ESSE_E)
          end
        end

        def stem_of_posse
          if @modus == t.infinitivum
            "po" + stem_of_esse[1..-1]
          else
            esse_stem = stem_of_esse
            potis = esse_stem =~ /^s/ ? "pos" : "pot"
            potis + esse_stem
          end
        end

        private

        def thematic_participium
          if @inflection_class == 3 || @inflection_class == 4 || @inflection_class == :ferre
            n(:THEMATIC_E)
          elsif @inflection_class == 5
            n(:THEMATIC_I) + n(:THEMATIC_E)
          elsif  @inflection_class == :ire
            if iens
              if @modus == t.gerundium || @modus == t.gerundivum
                n(:THEMATIC_U)
              else
                n(:THEMATIC_E)
              end
            else
              n(:THEMATIC_U)
            end
          else
            ""
          end
        end
        alias :thematic_gerundivum :thematic_participium
        alias :thematic_gerundium :thematic_participium

        def thematic_coniunctivus
          if @inflection_class == 5
            n(:THEMATIC_I)
          else
            ""
          end
        end

        def thematic_infinitivum
          if c_or_m_conjugation
            usual_thematic_vowels
          elsif @inflection_class == :fieri
            n(:THEMATIC_E)
          end
        end
        def thematic_indicativus
          send("thematic_indicativus_" + "#{inflection_class}")
        end
        alias :thematic_imperativus :thematic_indicativus

        def thematic_indicativus_esse
          if @persona == 1 || third_pl
            n(:THEMATIC_U)
          else
            ""
          end
        end
        alias :thematic_indicativus_posse :thematic_indicativus_esse
        alias :thematic_indicativus_fieri :thematic_indicativus_esse

        def thematic_indicativus_ferre
          if (@persona == 1 && @numerus == 2) || (@persona == 2 && @numerus == 2 && @genus == t.pass)
            n(:THEMATIC_I)
          elsif third_pl
            n(:THEMATIC_U)
          else
            ""
          end
        end
        alias :thematic_indicativus_edere :thematic_indicativus_ferre

        def thematic_indicativus_velle
          if @persona == 1 && @numerus == 2
            n(:THEMATIC_U)
          elsif third_pl
            n(:THEMATIC_U)
          else
            ""
          end
        end
        alias :thematic_indicativus_nolle :thematic_indicativus_velle
        alias :thematic_indicativus_malle :thematic_indicativus_velle

        def thematic_indicativus_ire
          if third_pl
            n(:THEMATIC_U)
          else
            ""
          end
        end
        alias :thematic_indicativus_fieri :thematic_indicativus_ire

        def thematic_indicativus_1
        end

        def thematic_indicativus_2
        end

        def thematic_indicativus_5
          if @ending =~ /^o/
            n(:THEMATIC_I)
          elsif third_pl
            n(:THEMATIC_I) + n(:THEMATIC_U)
          else
            usual_thematic_vowels
          end
        end
      end

      class ImperfectumSegments < VerbSegments
        def stem_of_esse
          case @modus
          when t.indicativus then "er"
          when t.coniunctivus then n(:STEM_ESSE_ES)
          end
        end

        def stem_of_edere
          case @modus
          when t.indicativus then "ed"
          when t.coniunctivus then "es"
          end
        end

        def stem_of_posse
          case @modus
          when t.indicativus then "pot" + stem_of_esse
          when t.coniunctivus then "po" + stem_of_esse[1..-1]
          end
        end

        def stem_of_velle
          if @modus == t.indicativus
            "vol"
          else
            "vel"
          end
        end

        def stem_of_ire
          "i"
        end

        def extension
          send("extension_" + modus_term)
        end

        private

        def extension_coniunctivus
          case @inflection_class
          when ->(x) { %i{ esse posse edere }.include?(x) } then n(:IMPERFECTUM_CONIUNCTIVUS_SE)
          when ->(x) { %i{ velle nolle malle }.include?(x) } then n(:IMPERFECTUM_CONIUNCTIVUS_LE)
          else
            n(:IMPERFECTUM_CONIUNCTIVUS)
          end
        end

        def extension_indicativus
          case @inflection_class
          when :esse then n(:IMPERFECTUM_INDICATIVUS_ESSE)
          when :posse then n(:IMPERFECTUM_INDICATIVUS_ESSE)
          else
            n(:IMPERFECTUM_INDICATIVUS) #ba
          end
        end

        def thematic_coniunctivus
          if c_or_m_conjugation || @inflection_class == :fieri
            n(:THEMATIC_E)
          else
            ""
          end
        end

        def thematic_indicativus
          arr = %i{ edere ferre velle nolle malle fieri }

          case @inflection_class
          when 5 then n(:THEMATIC_I) + n(:THEMATIC_E)
          when 3 then n(:THEMATIC_E)
          when 4 then n(:THEMATIC_E)
          when ->(x) { arr.include?(x) } then n(:THEMATIC_E)
          end
        end
      end

      class PerfectStemSegments < VerbSegments
        def thematic
          ""
        end

        def stem_of_ferre
          "tul"
        end
      end

      class PerfectumSegments < PerfectStemSegments
        def extension
          if @modus == t.coniunctivus
            n(:PERFECTUM_SUFFIX_1) + n(:PERFECTUM_CONIUNCTIVUS)
          else
            ""
          end
        end
      end

      class PlusquamperfectumSegments < PerfectStemSegments
        def extension
          if @modus == t.indicativus
            n(:PERFECTUM_SUFFIX_1) + n(:PLUSQUAMPERFECTUM_INDICATIVUS)
          else
            n(:PERFECTUM_SUFFIX_2) + n(:PLUSQUAMPERFECTUM_CONIUNCTIVUS)
          end
        end
      end

      class FuturumSegments < VerbSegments
        def stem_of_velle
          "vol"
        end

        def stem_of_edere
          case @modus
          when t.indicativus then "ed"
          when t.imperativus then edere_fut_imps
          end
        end

        def stem_of_esse
          case @modus
          when t.indicativus then "er"
          when t.imperativus then esse_fut_imps
          end
        end

        def stem_of_posse
          "pot" + stem_of_esse
        end

        def stem_of_ire
          if @modus == t.imperativus
            if third_pl
              "e"
            end
          else
            "i"
          end
        end

        def edere_fut_imps
          if third_pl
            "ed"
          else
            "es"
          end
        end

        def esse_fut_imps
          if third_pl
            n(:STEM_ESSE_S)
          else
            n(:STEM_ESSE_ES)
          end
        end

        def extension
          if @modus == t.indicativus
            futurum_sign
          else
            ""
          end
        end

        private

        def thematic_imperativus
          #refactor pending
          case @inflection_class
          when 1..2 then ""
          when 4 then special_thematic_for_i_conj
          when 3 then usual_thematic_vowels
          when 5 then thematic_imperativus_5
          else thematic_imperativus_esse # esse ferre edere fieri nolle ire
          end
        end

        def thematic_imperativus_5
          if third_pl
            n(:THEMATIC_I) + n(:THEMATIC_U)
          else
            usual_thematic_vowels
          end
        end

        def thematic_imperativus_esse
          if third_pl
            n(:THEMATIC_U)
          else
            ""
          end
        end

        def futurum_sign
          if a_or_e_conjugation || @inflection_class == :ire
            n(:FUTURUM_A)
          elsif @inflection_class == :esse || @inflection_class == :posse
            ""
          else
            futurm_signs_c
          end
        end

        def futurm_signs_c
          if first_sg
            n(:FUTURUM_C_1)
          else
            n(:FUTURUM_C)
          end
        end

        def thematic_indicativus
          case @inflection_class
          when 1 then usual_thematic_vowels
          when 2 then usual_thematic_vowels
          when 5 then n(:THEMATIC_I)
          when :esse then usual_thematic_vowels
          when :posse then usual_thematic_vowels
          when :ire then usual_thematic_vowels
          end
        end
      end

      class FuturumExactumSegments < PerfectStemSegments
        def thematic
          ""
        end

        def extension
          if first_sg
            n(:PERFECTUM_SUFFIX_1)
          else
            n(:PERFECTUM_SUFFIX_1) + n(:FUTURUM_EXACTUM_INDICATIVUS)
          end
        end
      end
    end
  end
end
