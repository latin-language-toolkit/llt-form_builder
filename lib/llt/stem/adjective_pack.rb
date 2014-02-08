module LLT
  class Stem
    class AdjectivePack < Pack
      def initialize(type, args, source, extension = true)
        # always extend
        super
        @lemma = @stems.first.nominative
      end

      def to_hash(use = nil, options = {})
       selector = case options[:comparison_sign].to_s
                  when /^(|i?t?er)$/ then :positivus # regular pos or adverbs
                  when /(ior|ius)/   then :comparativus
                  else :superlativus
                  end

        stem = @stems.find { |st| st.comparatio == selector }
        stem.to_hash.merge(options: options)
      end

      def third_decl_with_possible_ne_abl?
        super do
          st = @stems.find { |stem| stem.comparatio == :positivus }
          st ? st.third_decl_with_possible_ne_abl? : false
        end
      end

      def o_decl_with_possible_ne_voc?
        super do
          st = @stems.find { |stem| stem.comparatio == :positivus }
          st ? st.o_decl_with_possible_ne_voc? : false
        end
      end

      private

      def extended_stems(args)
        @stems = []
        @args  = args

        compute_comparatio_stems

        @stems
      end

      STEMS = %i{ positivus comparativus superlativus }
      def compute_comparatio_stems
        STEMS.each do |level|
          sc = (level != :positivus)
          build_as(level, sc)
        end
      end

      def build_as(level, stem_change = false)
        new_args = @args.merge(comparatio: level)

        if stem_change
          new_stem = send("#{level}_sign")
          new_args[:stem] = new_stem
          new_args.delete(:nom)
        end

        check_irregularities(new_args)

        add(create_stem(new_args))
      end

      # Creates Irregular Adverb stems like of bonus.
      # If none such is built, later stages will just use
      # the usual positivus stem.
      def check_irregularities(args)
        stem = args[:stem]
        if stem.match(irregular_adverbs)
          args[:irregular_adverb] = true
          new_stem = select_adverb_stem($1)
          add(create_stem(:adverb, args.merge(stem: new_stem)))
        end
      end

      def select_adverb_stem(match)
        case match
        when "bon"      then "ben"
        when "difficil" then "difficul"
        end
      end

      def irregular_adverbs
        /^(bon|difficil)$/
      end

      def comparativus_sign
        old_stem = @args[:stem].clone
        old_stem << "ior"
      end

      def superlativus_sign
        old_stem = @args[:stem].clone
        ext = case old_stem
              when /l$/ then "lim"
              when /r$/ then "rim"
              else "issim"
              end

        new_stem = send("#{ext}_sup_rules", old_stem)
        new_stem << ext
      end

      def rim_sup_rules(stem)
        if stem =~ /^(veter)$/
          stem
        else
          @args[:nom].clone
        end
      end

      def lim_sup_rules(stem)
        stem
      end

      def issim_sup_rules(stem)
        stem
      end

      def add(stem)
        @stems << stem
      end
    end
  end
end
