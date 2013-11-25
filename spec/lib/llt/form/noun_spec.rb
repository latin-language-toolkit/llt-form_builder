require 'spec_helper'

describe LLT::Form::Noun do
  let(:noun) { LLT::Form::Noun.new({}) }

  it "has functions noun and substantive" do
    noun.has_f?(:noun).should be_true
    noun.has_f?(:substantive).should be_true
  end

  describe "#stems=" do
    it "sets a noun's stems" do
      dummy = double
      noun.stems = dummy
      noun.stems.should == dummy
    end
  end
end
