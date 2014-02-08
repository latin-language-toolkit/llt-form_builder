require 'spec_helper'

describe LLT::Stem::NounStem do
  let(:ns) { LLT::Stem::NounStem }
  describe "#third_decl_with_possible_ne_abl?", :focus do
    context "matches correctly" do
      it "with words like ratio" do
        stem = ns.new(:noun, { nom: "ratio", stem: "ration", inflection_class: 3 })
        stem.third_decl_with_possible_ne_abl?.should be_true
      end

      it "with words like multitudo" do
        stem = ns.new(:noun, { nom: "multitudo", stem: "multitudin", inflection_class: 3 })
        stem.third_decl_with_possible_ne_abl?.should be_true
      end

      it "with words like Cicero" do
        stem = ns.new(:noun, { nom: "Cicero", stem: "Ciceron", inflection_class: 3 })
        stem.third_decl_with_possible_ne_abl?.should be_true
      end

      it "with words like finis" do
        stem = ns.new(:noun, { nom: "finis", stem: "fin", inflection_class: 33 })
        stem.third_decl_with_possible_ne_abl?.should be_true
      end
    end

    context "doesn't produce false positives" do
      it "for other third declension nouns" do
        stem = ns.new(:noun, { nom: "miles", stem: "milit", inflection_class: 3 })
        stem.third_decl_with_possible_ne_abl?.should be_false
      end
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
