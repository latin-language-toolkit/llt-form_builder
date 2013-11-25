require 'spec_helper'

describe LLT::Form::Verb do
  describe "#init_function" do
    it "returns the correct initial functions of a verb" do
      pending
      options = { ending: "i" }
      args = [{type: :perfectum, stem: "amav", inflection_class: 1, options: options}]
      verb = LLT::FormBuilder.build(*args).first
      verb.init_function.should == [:verb]
    end
  end
end
