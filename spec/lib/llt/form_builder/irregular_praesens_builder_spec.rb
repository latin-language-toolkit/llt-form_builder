require 'spec_helper'

describe LLT::FormBuilder do
  describe ".build" do
    context "with options" do
      it "builds the form fiebat" do
        opts = {:stem=>"fi", :thematic=>"e", :extension=>"ba", :ending=>"t", validate: true}
        args = { type: :praesens, inflection_class: :fieri, options: opts}
        forms = LLT::FormBuilder.build(args)
        forms.should have(1).item
      end
    end
  end
end
