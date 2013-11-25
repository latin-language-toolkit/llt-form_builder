require 'llt/helpers'
require 'llt/constants'

module LLT
  class Form
    require 'llt/form/declinable'
    require 'llt/form/uninflectable'
    require 'llt/form/adverb'
    require 'llt/form/cardinal'
    require 'llt/form/verbal_noun'
    require 'llt/form/participle'
    require 'llt/form/ppa'
    require 'llt/form/ppp'
    require 'llt/form/fp'
    require 'llt/form/gerundive'
    require 'llt/form/gerund'
    require 'llt/form/infinitive'
    require 'llt/form/pronoun'
    require 'llt/form/indefinite_pronoun'
    require 'llt/form/relative_pronoun'
    require 'llt/form/demonstrative_pronoun'
    require 'llt/form/interrogative_pronoun'
    require 'llt/form/personal_pronoun'
    require 'llt/form/preposition'
    require 'llt/form/conjunction'
    require 'llt/form/subjunction'
    require 'llt/form/supinum'
    require 'llt/form/verb'

    include Helpers::Constantize
    include Helpers::Initialize
    include Helpers::Functions
    include Helpers::Normalizer
    include Helpers::Metrical


    attr_accessor :string, :stem, :ending, :inflection_class, :casus, :numerus, :sexus,
                  :comparison_sign, :index, :modus, :tempus, :genus, :extension, :persona, :stems,
                  :particle, :place, :suffix, :prefix, :classification

    def initialize(args)
      extract_args!(args)
      @string = args[:string] || segments.join # a custom string might be present for irregular forms
      evaluate_metrical_presence(@string)
    end

    def init_keys
      %i{ inflection_class index classification }
    end

    # Should be called through super by subclasses
    def init_functions
      [class_name_to_sym]
    end

    def functions
      @functions ||= Set.new(init_functions)
    end

    def segmentized
      segments.compact * "-"
    end

    def to_s(in_segments = false)
      if in_segments
        segmentized
      else
        @string
      end
    end
    alias :inspect :to_s

    private

    def class_name_to_sym
      cl_name = self.class.name.split('::').last
      cl_name.gsub(/([a-z])([A-Z])/, '\1_\2').downcase.to_sym
    end
  end
end
