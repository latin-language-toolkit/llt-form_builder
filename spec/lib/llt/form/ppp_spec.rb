require 'spec_helper'

describe LLT::Form::Ppp do
  let(:ppp) { LLT::Form::Ppp.new({}) }

  it "has functions ppp, substantive, adjective and participle" do
    ppp.has_f?(:ppp).should be_true
    ppp.has_f?(:substantive).should be_true
    ppp.has_f?(:adjective).should be_true
    ppp.has_f?(:participle).should be_true
  end
end
