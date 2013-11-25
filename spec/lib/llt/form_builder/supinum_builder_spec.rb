require 'spec_helper'

describe LLT::FormBuilder do
  include LLT::Helpers::Normalizer

  describe ".build" do
    #def form_builder_strings(args)
    #  forms = LLT::FormBuilder.build(*args)
    #  forms.map(&:to_s)
    #end

    context "with supina" do
      it "builds all forms" do
        args = [{type: :supinum, stem: "amat", inflection_class: 1, tense: :pf}]
        forms = LLT::FormBuilder.build(*args)
        forms.map(&:to_s).should == %w{ amatu amatum amatu }
        forms[0].casus.should == 3
        forms[1].casus.should == 4
        forms[2].casus.should == 6
      end
    end
  end
end

