require 'spec_helper'

describe LLT::Stem::NounStem do
  let(:ns) { LLT::Stem::NounStem }
  describe "#third_decl_with_possible_ne_abl?" do
    it "does what it should" do
      stem = ns.new(:noun, { nom: "ratio", stem: "ration", inflection_class: 3 })
      stem.third_decl_with_possible_ne_abl?.should be_true

      stem = ns.new(:noun, { nom: "miles", stem: "milit", inflection_class: 3 })
      stem.third_decl_with_possible_ne_abl?.should be_false
    end
  end

  describe "#o_decl_with_possible_ne_voc?" do
    it "does what it should" do
      stem = ns.new(:noun, { nom: "dominus", inflection_class: 2 })
      stem.o_decl_with_possible_ne_voc?.should be_true

      stem = ns.new(:noun, { nom: "ager", inflection_class: 2 })
      stem.o_decl_with_possible_ne_voc?.should be_false
    end
  end
end
