require 'spec_helper'

describe LLT::Form::Verb do
  let(:verb) { LLT::Form::Verb.new({}) }

  it "has function verb" do
    verb.has_f?(:verb)
  end

  it "has a function named after its conjugation with irregular verbs" do
    verb.instance_variable_set('@inflection_class', :esse)
    verb.has_f?(:esse).should be_true
  end
end
