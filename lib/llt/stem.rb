require 'llt/helpers'

module LLT
  class Stem
    include Helpers::Initialize
    include Helpers::Transformer
    include Helpers::Normalizer

    files = %w{ noun_stem verb_stem adjective_stem ethnic_stem
                pack noun_pack verb_pack adjective_pack }
    files.each do |file|
      require "llt/stem/#{file}"
    end

    attr_reader :type, :stem

    def initialize(type, args)
      @type = t.send(type, :full)
      extract_normalized_args!(args)
    end
  end
end
#class Stem
#  attr_reader :stem, :metrical, :detailed_type
#
#  include LLT::Helpers::Initialize
#  include LLT::Helpers::Transformer
#
#  # this should hold inflection type info as well
#  # subclass for type
#
#  def initialize(type, stem, metrical = nil, args)
#    @type = type
#    @stem = stem
#    @metrical = metrical
#    extract_args!(args)
#  end
#
#  def init_keys
#    %i{ special_info }
#  end
#
#  def unicode
#    @stem
#  end
#
#  def to_s
#    "#{type_info}:\t#{stem} (#{@metrical})\t#{@special_info}"
#  end
#  alias :inspect :to_s
#
#  def type_info
#    shortened_type
#  end
#
#  def shortened_type
#    case @type
#    when :adverb      then :adv
#    when :conjunction then :conj
#    else @type
#    end
#  end
#
#  def type
#    @type ||= self.class.name.chomp("Stem").downcase.to_sym
#  end
#
#  def inflectable_class_type
#    @inflectable_class
#  end
#end
#
#class ComplexStem < Stem
#  def init_keys
#    super + %i{ inflectable_class }
#  end
#
#  def type_info
#    "#{super} #{inflectable_class_type} #{additional_stem_info}"
#  end
#end
#
#class VerbStem < ComplexStem
#  # what happens when a lemma has two different stems? it infl class right, even for perfstems?
#  def init_keys
#    super + %i{ tense deponens }
#  end
#
#  def additional_stem_info
#    @tense
#  end
#
#  def type_info
#    super + (@deponens ? " #{dep_status}" : "")
#  end
#
#  def dep_status
#    "dep".green if @deponens
#  end
#end
#
##class NounStem < ComplexStem
##  def init_keys
##    super + %i{ sexus } # nominative?
##  end
##
##  def additional_stem_info
##    @sexus
##  end
##
##  def inflectable_class_type
##    case @inflectable_class
##    when 1  then "A"
##    when 2  then "O"
##    when 3  then "C"
##    when 31 then
##    when 32 then
##    when 33 then
##    when 4  then "U"
##    when 5  then "E"
##    end
##  end
##end
#
#class AdjectiveStem < ComplexStem
#  def init_keys
#    super + %i{ number_of_endings }
#  end
#
#  def additional_stem_info
#    @number_of_endings
#  end
#
#  def shortened_type
#    :adj
#  end
#
#  def inflectable_class_type
#    case @inflectable_class
#    when 1 then "A/O"
#    when 3 then "Third"
#    when 5 then "Pronominal"
#    end
#  end
#end
