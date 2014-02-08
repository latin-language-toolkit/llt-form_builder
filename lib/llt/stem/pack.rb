require 'llt/helpers'

module LLT
  class Stem
    class Pack
      include Helpers::Transformer
      include Helpers::Constantize
      include Helpers::Normalizer

      attr_reader :stems, :type, :lemma_key, :lemma

      def initialize(type, args, source, extension = false)
        @type = type
        @source = source
        @lemma_key = args[:lemma_key]
        @stems = (extension ? extended_stems(args) : default_stem(args))
      end

      def lemma_with_key
        "#{@lemma}##{@lemma_key}"
      end

      def to_hash(use = nil, options = {})
        @stems.first.to_hash.merge(options: options)
      end

      def to_s
        @stems.map(&:to_s) * ", "
      end

      private

      def create_stem(stem_type = @type, args)
        constant_by_type(suffix: "stem", namespace: LLT::Stem).new(stem_type, args)
      end

      def default_stem(args)
        [create_stem(args)]
      end

      def third_decl_with_possible_ne_abl?
        block_given? ? yield : false
      end

      def third_decl_with_possible_ve_abl?
        block_given? ? yield : false
      end

      def o_decl_with_possible_ne_voc?
        block_given? ? yield : false
      end
    end
  end
end
