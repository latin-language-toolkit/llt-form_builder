require 'spec_helper'
require 'llt/stem_builder'

describe LLT::StemBuilder do
  context "with personae or places" do
    it "changes a persona type to noun and adds a persona attribute to the args hash" do
      type = :persona
      args = {}
      LLT::StemBuilder.parse_type_and_extend_args(type, args).should == :noun
      args[:persona].should be_true
    end

    it "does the same to places" do
      type = :place
      args = {}
      LLT::StemBuilder.parse_type_and_extend_args(type, args).should == :noun
      args[:place].should be_true
    end
  end
end
