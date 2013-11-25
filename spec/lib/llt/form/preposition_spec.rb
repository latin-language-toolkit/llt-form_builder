require 'spec_helper'

describe LLT::Form::Preposition do
  describe "#takes_4th?" do
    it "returns true if an acc is taken" do
      args = { string: 'super', takes_4th: true, takes_6th: false }
      prep = LLT::Form::Preposition.new(args)
      prep.takes_4th?.should be_true
    end
  end

  describe "#takes_6th?" do
    it "returns true if an abl is taken" do
      args = { string: 'ex', takes_4th: false, takes_6th: true }
      prep = LLT::Form::Preposition.new(args)
      prep.takes_6th?.should be_true
    end
  end

  describe "#string" do
    it "returns the string value" do
      args = { string: 'ex', takes_4th: false, takes_6th: true }
      prep = LLT::Form::Preposition.new(args)
      prep.string.should == 'ex'
    end
  end

  describe "#stem" do
    it "is an alias for string" do
      args = { string: 'ex', takes_4th: false, takes_6th: true }
      prep = LLT::Form::Preposition.new(args)
      prep.stem.should == 'ex'
    end
  end

  describe "#lemma" do
    it "is another alias for string" do
      args = { string: 'ex', takes_4th: false, takes_6th: true }
      prep = LLT::Form::Preposition.new(args)
      prep.lemma.should == 'ex'
    end
  end
end
