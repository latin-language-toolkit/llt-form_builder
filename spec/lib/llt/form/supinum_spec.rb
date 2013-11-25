require 'spec_helper'

describe LLT::Form::Supinum do
  let(:supinum) { LLT::Form::Supinum.new({}) }

  it "has function supinum" do
    supinum.has_f?(:supinum).should be_true
  end
end
