require 'spec_helper'

describe LLT::FormBuilder do
  describe ".build" do
    context "with irregular praesens infinitive" do
      context "with options" do
        it "builds the form esse" do
          opts = {:stem=>"es", :ending=>"se"}
          args = { type: :praesens, inflection_class: :esse, options: opts}
          forms = LLT::FormBuilder.build(args)
          forms.should have(1).item
        end

        it "builds the form posse" do
          opts = {:stem=>"pos", :ending=>"se"}
          args = { type: :praesens, inflection_class: :posse, options: opts}
          forms = LLT::FormBuilder.build(args)
          forms.should have(1).item
        end

        it "builds the form abesse" do
          opts = {:stem=>"es", :prefix=>"ab", :ending=>"se"}
          args = { type: :praesens, inflection_class: :esse, options: opts}
          forms = LLT::FormBuilder.build(args)
          forms.should have(1).item
          forms.first.to_s(:segmentized).should == "ab-es-se"
        end
      end
    end
  end
end

