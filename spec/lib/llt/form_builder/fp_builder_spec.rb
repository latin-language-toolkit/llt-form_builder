require 'spec_helper'

describe LLT::FormBuilder do
  include LLT::Helpers::Normalizer

  describe ".build" do
    def form_builder_strings(args)
      forms = LLT::FormBuilder.build(*args)
      forms.map(&:to_s)
    end

    context "with fp" do
      it "builds all forms - a conj" do
        args = [{type: :fp, stem: "amat", inflection_class: 1, tense: :pf}]
        form_builder_strings(args).should == %w{ amaturus amaturi amaturo amaturum amature amaturo amaturi amaturorum amaturis amaturos amaturi amaturis
                                                   amatura amaturae amaturae amaturam amatura amatura amaturae amaturarum amaturis amaturas amaturae amaturis
                                                   amaturum amaturi amaturo amaturum amaturum amaturo amatura amaturorum amaturis amatura amatura amaturis }
      end

      context "with options that select a specfic form given in a stem" do
        it "builds correct forms only (several possibilities)" do
          options = { casus: 2 }
          args = [{type: :fp, stem: "amat", inflection_class: 1,
            tense: :fut, options: options}]
          forms = LLT::FormBuilder.build(*args)

          forms.should have(6).items
          form = forms[2]

          form.casus.should == 2
          form.numerus.should == 1
          form.sexus.should == :f

          form.participium?.should be_true

          form.tempus.should == t.fut
          form.genus.should  == t.act
        end
      end
    end
  end
end
