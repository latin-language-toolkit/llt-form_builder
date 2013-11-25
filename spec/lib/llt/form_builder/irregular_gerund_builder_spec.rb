require 'spec_helper'

describe LLT::FormBuilder do
  describe ".build" do
    context "with irregular gerundiva" do
      context "with gerundives" do
        context "with options that select a specfic form given in a stem" do
          context "with validate flag" do
            it "builds correct forms only" do
              options = { prefix: "ad", ending: "um" }
              args = [{type: :irregular_gerund, inflection_class: :ferre, options: options}]
              forms = LLT::FormBuilder.build(*args)
              forms.should have(1).item
              forms.first.to_s(:segmentized).should == "ad-fer-e-nd-um"
            end
          end
        end
      end
    end
  end
end

