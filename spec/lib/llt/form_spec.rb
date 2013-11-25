require 'spec_helper'

describe LLT::Form do
  describe '#init_functions' do
    it 'always contains a function name derived from the class name' do
      verb = LLT::Form::Verb.new({})
      noun = LLT::Form::Noun.new({})
      prep = LLT::Form::Preposition.new({})

      verb.functions.should include :verb
      noun.functions.should include :noun
      prep.functions.should include :preposition
    end
  end

  describe "#has_f?, #has_function?, #has_not_f?, #has_not_function?" do
    it "queries an objects functions" do
      verb = LLT::Form::Verb.new({})

      verb.has_f?(:verb).should be_true
      verb.has_function?(:noun).should be_false

      verb.has_not_f?(:verb).should be_false
      verb.has_not_function?(:noun).should be_true
    end
  end
end
