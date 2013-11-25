require 'spec_helper'

describe LLT::Form::Adverb do
  describe "#string" do
    it "returns the string value" do
      adv = LLT::Form::Adverb.new(string: 'semper')
      adv.string.should == 'semper'
    end
  end

  describe "#stem" do
    it "is an alias for string" do
      adv = LLT::Form::Adverb.new(string: 'semper')
      adv.stem.should == 'semper'
    end
  end
end
