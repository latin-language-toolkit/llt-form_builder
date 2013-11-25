require 'spec_helper'

describe LLT::FormBuilder do
  describe ".build" do
    it "builds the correct adverb form - positivus" do
      args = { type: :adverb, comparatio: :positivus, stem: "alt", inflection_class: 1 }
      forms = LLT::FormBuilder.build(args)
      forms.should have(1).item
      forms.first.to_s(:segmentized).should == "alt-e"
    end

    it "builds the correct adverb form - comparativus" do
      args = { type: :adverb, comparatio: :comparativus, stem: "altius", inflection_class: 1 }
      forms = LLT::FormBuilder.build(args)
      forms.should have(1).item
      forms.first.to_s(:segmentized).should == "alt-ius"
    end

    it "builds the correct adverb form - superlativus" do
      args = { type: :adverb, comparatio: :superlativus, stem: "altissim", inflection_class: 1 }
      forms = LLT::FormBuilder.build(args)
      forms.should have(1).item
      forms.first.to_s(:segmentized).should == "alt-issim-e"
    end
  end

end
