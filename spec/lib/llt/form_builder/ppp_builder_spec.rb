require 'spec_helper'

describe LLT::FormBuilder do
  include LLT::Helpers::Normalizer

  describe ".build" do
    def form_builder_strings(args)
      forms = LLT::FormBuilder.build(*args)
      forms.map(&:to_s)
    end

    context "with ppp" do
      context "build all forms" do
        it "a conj" do
          args = [{type: :ppp, stem: "amat", inflection_class: 1, options: { tempus: :pf }}]
          form_builder_strings(args).should == %w{ amatus amati amato amatum amate amato amati amatorum amatis amatos amati amatis
                                                   amata amatae amatae amatam amata amata amatae amatarum amatis amatas amatae amatis
                                                   amatum amati amato amatum amatum amato amata amatorum amatis amata amata amatis }
        end
      end

      context "with options that select a specfic form given in a stem" do
        it "builds correct forms only (several possibilities)" do
          options = { casus: 3, numerus: 2 }
          args = [{type: :ppp, stem: "amat", inflection_class: 1, options: options}]
          forms = LLT::FormBuilder.build(*args)

          forms.should have(6).items # 3 forms ppp, 3 forms fp
          form = forms.first

          form.casus.should == 3
          form.numerus.should == 2
          form.sexus.should == :m

          form.participium?.should be_true
          form.part?.should be_true
          form.participle?.should be_true

          form.tempus.should == t.pf
          form.genus.should  == t.passivum
        end
      end
    end
  end
end
