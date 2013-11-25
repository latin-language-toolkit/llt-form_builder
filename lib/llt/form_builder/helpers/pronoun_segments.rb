require 'llt/helpers'
require 'llt/constants/particles'

module LLT
  class FormBuilder
    class PronounSegments
      extend Helpers::Constantize
      include Helpers::Initialize

      class << self
        def get(request, args)
          cl = constant_by_type(args[:inflection_class], prefix: "pronoun", namespace: self)
          cl.new(args).send(request)
        end

        def particle(arg)
          define_method(:particle) { arg }
        end

        def stem(arg)
          define_method(:stem) { arg }
        end

        def prefixed_particle(arg)
          define_method(:prefixed_particle) { arg }
        end

        def n(const)
          LLT::Constants::Particles.const_get(const)
        end
      end

      def initialize(args)
        extract_args!(args)
      end

      def init_keys
        %i{ casus numerus sexus }
      end

      def n(const)
        self.class.n(const)
      end

      def particle
        ""
      end

      def prefixed_particle
        ""
      end

      class PronounHic < PronounSegments
        def particle
          if (@numerus == 1 && @casus != 2) || (@sexus == :n && @numerus == 2 && (@casus == 1 || @casus == 4))
            n(:C)
          else
            ""
          end
        end

        def stem
          if @numerus == 1 && (@casus == 2 || @casus == 3)
            "hu"
          else
            "h"
          end
        end
      end

      class PronounIlle < PronounSegments
        stem "ill"
      end

      class PronounIpse < PronounSegments
        stem "ips"
      end

      class PronounIste < PronounSegments
        stem "ist"
      end

      class PronounIs < PronounSegments
        def stem
          if @numerus == 1 && ((@casus == 1 && (@sexus == :m || @sexus == :n)) || (@casus == 4 && @sexus == :n)) || @numerus == 2 && @casus == 1 && @sexus == :m
            "i"
          else
            "e"
          end
        end
      end

      class PronounQui < PronounSegments
        def stem
          if cuius_and_cui
            "cu"
          else
            "qu"
          end
        end

        def cuius_and_cui
          @numerus == 1 && (@casus == 2 || @casus == 3)
        end
      end

      class PronounIs < PronounSegments
        def stem
          if @numerus == 1 && ((@casus == 1 && (@sexus == :m || @sexus == :n)) || (@casus == 4 && @sexus == :n)) || @numerus == 2 && @casus == 1 && @sexus == :m
            "i"
          else
            "e"
          end
        end
      end

      class PronounIdem < PronounIs
        particle n(:DEM)
      end

      class PronounQui < PronounSegments
        def stem
          if cuius_and_cui
            "cu"
          else
            "qu"
          end
        end

        def cuius_and_cui
          @numerus == 1 && (@casus == 2 || @casus == 3)
        end
      end

      PronounQuis = PronounQui

      class PronounQuidam < PronounQui
        particle n(:DAM)
      end

      class PronounQuicumque < PronounQui
        particle n(:CUMQUE)
      end

      class PronounQuinam < PronounQui
        particle n(:NAM)
      end

      class PronounQuispiam < PronounQui
        particle n(:PIAM)
      end

      class PronounQuilibet < PronounQui
        particle n(:LIBET)
      end

      class PronounQuivis < PronounQui
        particle n(:VIS)
      end

      class PronounQuisqueS < PronounQui
        particle n(:QUE)
      end
      PronounQuisque = PronounQuisqueS

      class PronounQuisquam < PronounQui
        particle n(:QUAM)
      end

      class PronounUnusquisque < PronounQui
        particle n(:QUE)

        def prefixed_particle
          opts = { casus: @casus, numerus: @numerus, sexus: @sexus, validate: true }
          args = { type: :adjective, stem: "un", inflection_class: 5,
                   noe: 3, comparatio: :positivus, options: opts }
          FormBuilder.build(args).first.to_s
        end
      end
      class PronounUnusquisqueS < PronounUnusquisque
        def prefixed_particle
          # unaquisque does not exist - unusquisque is for m and f
          if @casus == 1 && @numerus == 1 && @sexus != :n
            "unus"
          else
            super
          end
        end
      end

      class PronounQuisquis < PronounQui
        def init_keys
          super << :ending
        end

        def particle
          stem + @ending
        end
      end

      class PronounAliqui < PronounQui
        prefixed_particle n(:ALI)
      end
      PronounAliquis = PronounAliqui

      class PronounUter < PronounSegments
        def stem
          if uter
            "uter"
          else
            "utr"
          end
        end

        def uter
          @casus == 1 && @numerus == 1 && @sexus == :m
        end
      end

      class PronounUterque < PronounUter
        particle n(:QUE)
      end

    end
  end
end
