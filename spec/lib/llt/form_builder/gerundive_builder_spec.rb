require 'spec_helper'

describe LLT::FormBuilder do
  include LLT::Helpers::Normalizer

  describe ".build" do
    def form_builder_strings(args)
      forms = LLT::FormBuilder.build(*args)
      forms.map(&:to_s)
    end

    context "with gerundiva" do
      context "build all forms" do
        it "a conj" do
          args = [{type: :gerundive, stem: "ama", inflection_class: 1, tense: :pr}]
          form_builder_strings(args).should == %w{ amandus amandi amando amandum amande amando amandi amandorum amandis amandos amandi amandis
                                                   amanda amandae amandae amandam amanda amanda amandae amandarum amandis amandas amandae amandis
                                                   amandum amandi amando amandum amandum amando amanda amandorum amandis amanda amanda amandis }
        end

        it "m conj" do
          args = [{type: :gerundive, stem: "cap", inflection_class: 5, tense: :pr}]
          form_builder_strings(args).should == %w{ capiendus capiendi capiendo capiendum capiende capiendo capiendi capiendorum capiendis capiendos capiendi capiendis
                                                   capienda capiendae capiendae capiendam capienda capienda capiendae capiendarum capiendis capiendas capiendae capiendis
                                                   capiendum capiendi capiendo capiendum capiendum capiendo capienda capiendorum capiendis capienda capienda capiendis }
        end
      end
    end

    context "with options that select a specfic form given in a stem" do
      context "with gerundives" do
        it "builds correct forms only (several possibilities)" do
          options = { numerus: 2 }
          args = [{type: :gerundive, stem: "ama", inflection_class: 1, options: options}]
          forms = LLT::FormBuilder.build(*args)

          forms.should have(18).items
          form = forms.last

          form.casus.should == 6
          form.numerus.should == 2
          form.sexus.should == :n
          form.ending.should == "is"
          form.extension.should == "nd"

          form.gerundive?.should be_true

          form.tempus.should be_nil
          form.genus.should  be_nil
        end

        it "builds correct forms only, ending given" do
          options = { ending: "um" }
          args = [{type: :gerundive, stem: "ama", inflection_class: 1, options: options}]
          forms = LLT::FormBuilder.build(*args)
          forms.should have(4).items
          forms.map(&:casus).should == [4, 1, 4, 5]
          forms.map(&:sexus).should == %i{ m n n n }
        end

        context "with validate flag" do
          it "needs the extension to be given" do
            options = { ending: "um", extension: "nd", validate: true }
            args = [{type: :gerundive, stem: "ama", inflection_class: 1, options: options}]
            forms = LLT::FormBuilder.build(*args)
            forms.should have(4).items
          end

          it "doesn't build forms when extension is not given" do
            # no extension given, no result
            options = { ending: "um", validate: true }
            args = [{type: :gerundive, stem: "ama", inflection_class: 1, options: options}]
            forms = LLT::FormBuilder.build(*args)
            forms.should be_empty
          end

          context "with archaic forms" do
            let(:archaic_forms) do
              options = { thematic: "u", extension: "nd", ending: "i", validate: true }
              args = { type: :gerundive, stem: "audi", inflection_class: 4, options: options }
              LLT::FormBuilder.build(args)
            end

            it "builds the correct forms" do
              archaic_forms.should have(4).items
              archaic_forms.map(&:numerus).should =~ [1, 2, 2, 1]
              archaic_forms.map(&:casus).should =~ [2, 1, 5, 2]
            end

            it "produces the correct string value for archaic forms" do
              archaic_forms.map(&:to_s).should == %w{ audiundi } * 4
            end

            it "marks forms as archaic" do
              archaic_forms.map(&:classification).should == %i{ archaic } * 4
            end
          end
        end
      end
    end
  end
end
