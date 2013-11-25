require 'spec_helper'

describe LLT::Form::Adjective do
  let(:adj) { LLT::Form::Adjective.new({}) }

  it "has functions adjective and substantive" do
    adj.has_f?(:adjective).should be_true
    adj.has_f?(:substantive).should be_true
  end
end
