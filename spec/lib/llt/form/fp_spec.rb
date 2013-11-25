require 'spec_helper'

describe LLT::Form::Fp do
  let(:fp) { LLT::Form::Fp.new({}) }

  it "has functions fp, substantive, adjective and participle" do
    fp.has_f?(:fp).should be_true
    fp.has_f?(:substantive).should be_true
    fp.has_f?(:adjective).should be_true
    fp.has_f?(:participle).should be_true
  end
end
