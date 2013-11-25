require 'spec_helper'

describe LLT::Form::Gerundive do
  let(:gerundive) { LLT::Form::Gerundive.new({}) }

  it "has function gerundive" do
    gerundive.has_f?(:gerundive).should be_true
  end

  it "has function substantive - to play the role of a dominant participle" do
    gerundive.has_f?(:substantive).should be_true
  end
end
