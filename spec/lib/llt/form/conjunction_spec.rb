require 'spec_helper'

describe LLT::Form::Conjunction do
  let(:conj) { LLT::Form::Conjunction.new(string: 'et') }

  describe "#string" do
    it "returns the string value" do
      conj.string.should == 'et'
    end
  end

  describe "#stem" do
    it "is an alias to string" do
      conj.stem.should == 'et'
    end
  end

  describe "#lemma" do
    it "is another alias for string" do
      conj.lemma.should == 'et'
    end
  end
end
