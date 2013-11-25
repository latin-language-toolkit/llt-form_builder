require 'spec_helper'

describe LLT::FormBuilder do
  include LLT::Helpers::Normalizer

  describe ".build" do
    def form_builder_strings(args)
      forms = LLT::FormBuilder.build(*args)
      forms.map(&:to_s)
    end

    context "with gerunds" do
      context "build all forms" do
        it "a conj" do
          args = [{type: :gerund, stem: "ama", inflection_class: 1, tense: :pr}]
          forms = LLT::FormBuilder.build(*args)
          forms.map(&:to_s).should == %w{ amandi amando amandum amando }
          forms[0].casus.should == 2
          forms[3].casus.should == 6
        end

        it "c conj" do
          args = [{type: :gerund, stem: "leg", inflection_class: 3, tense: :pr}]
          forms = LLT::FormBuilder.build(*args)
          forms.map(&:to_s).should == %w{ legendi legendo legendum legendo }
          forms[0].casus.should == 2
          forms[3].casus.should == 6
        end
      end
    end

    context "with options that select a specfic form given in a stem" do
      context "with gerunds" do
        it "builds correct forms only (several possibilities)" do
          options = { casus: 4 }
          args = [{type: :gerund, stem: "ama", inflection_class: 1, options: options}]
          forms = LLT::FormBuilder.build(*args)

          forms.should have(1).items
          form = forms[0]

          form.casus.should == 4
          form.numerus.should == 1
          form.sexus.should == :n
          form.ending.should == "um"
          form.extension.should == "nd"

          form.gerund?.should be_true

          form.tempus.should be_nil
          form.genus.should  be_nil
        end

        it "builds correct forms only, ending given" do
          options = { ending: "um" }
          args = [{type: :gerund, stem: "ama", inflection_class: 1, options: options}]
          forms = LLT::FormBuilder.build(*args)
          forms.should have(1).item
          forms.first.casus.should == 4
        end

        context "with validate flag" do
          it "doesn't build forms when extension is not given" do
            options = { ending: "um", validate: true }
            args = [{type: :gerund, stem: "ama", inflection_class: 1, options: options}]
            forms = LLT::FormBuilder.build(*args)
            forms.should be_empty
          end

          it "needs the extension to be given" do
            options = { ending: "um", extension: "nd", validate: true }
            args = [{type: :gerund, stem: "ama", inflection_class: 1, options: options}]
            forms = LLT::FormBuilder.build(*args)
            forms.should have(1).items
          end
        end
      end
    end
  end
end
