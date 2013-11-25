require 'spec_helper'

describe LLT::Form::Ppa do
  let(:ppa) { LLT::Form::Ppa.new({}) }

  it "has functions ppa, substantive, adjective and participle" do
    ppa.has_f?(:ppa).should be_true
    ppa.has_f?(:substantive).should be_true
    ppa.has_f?(:adjective).should be_true
    ppa.has_f?(:participle).should be_true
  end
end
