require 'spec_helper'

describe LLT::Form::DemonstrativePronoun do
  let(:dem_pron) { LLT::Form::DemonstrativePronoun.new({}) }

  it "has function demonstrative_pronoun" do
    dem_pron.has_f?(:demonstrative_pronoun).should be_true
  end

  it "includes its inflection_class in its functions" do
    dem_pron.instance_variable_set('@inflection_class', :hic)
    dem_pron.has_f?(:hic).should be_true
  end
end
