require 'spec_helper'

describe LLT::FormBuilder do
  describe ".build" do
    context "with ethnics" do
      context "with options" do
        it "builds only correct forms" do
          opts = { stem: "Haedu", ending: "orum" }
          args = { type: :ethnic, stem: "Haedu", inflection_class: 1, options: opts }
          forms = LLT::FormBuilder.build(args)
          forms.should have(2).items
          forms.first.to_s.should == "Haeduorum" # check if it's still capitalized
        end
      end
    end
  end
end
