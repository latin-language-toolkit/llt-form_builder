require 'spec_helper'

describe LLT::Form::Gerund do
  let(:gerund) { LLT::Form::Gerund.new({}) }

  it "has functions gerund, substantive" do
    gerund.has_f?(:gerund).should be_true
    gerund.has_f?(:substantive).should be_true
  end
end
