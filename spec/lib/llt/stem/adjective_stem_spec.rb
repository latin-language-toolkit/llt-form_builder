require 'spec_helper'

describe LLT::Stem::AdjectiveStem do
  let(:as) { LLT::Stem::AdjectiveStem }
  describe "#third_decl_with_possible_ne_abl?" do
    it "does what it should" do
      stem = as.new(:adjective, {nom: "communis", stem: "commun", inflection_class: 3})
      stem.third_decl_with_possible_ne_abl?.should be_true


      stem = as.new(:adjective, {nom: "facilis", stem: "facil", inflection_class: 3})
      stem.third_decl_with_possible_ne_abl?.should be_false
    end
  end
end
