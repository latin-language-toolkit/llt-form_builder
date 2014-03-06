require 'spec_helper'
describe LLT::FormBuilder do
  include LLT::Helpers::Normalizer

  describe ".build" do
    def form_builder_strings(args)
      forms = LLT::FormBuilder.build(*args)
      forms.map(&:to_s)
    end

    def with_noun_options(options)
      args = [{type: :noun, stem: "ros", inflection_class: 1, sexus: :f, options: options }]
      LLT::FormBuilder.build(*args)
    end

    context "with nouns" do
      context "without options" do
        it "builds all forms of A - nominative need not be given" do
          args = [{type: :noun, stem: "ros", inflection_class: 1, sexus: :f}]
          form_builder_strings(args).should == %w(rosa rosae rosae rosam rosa rosa rosae rosarum rosis rosas rosae rosis)
        end

        it "builds all forms of A - even if nominative is given" do
          args = [{type: :noun, nominative: "rosa", stem: "ros", inflection_class: 1, sexus: :f}]
          form_builder_strings(args).should == %w(rosa rosae rosae rosam rosa rosa rosae rosarum rosis rosas rosae rosis)
        end

        context "O - m " do
          it "builds all forms when no nominative is given" do
            args = [{type: :noun, stem: "amic", inflection_class: 2, sexus: :m}]
            form_builder_strings(args).should == %w(amicus amici amico amicum amice amico amici amicorum amicis amicos amici amicis)
          end

          it "builds all forms - handles vocative properly when nominative is given" do
            args = [{type: :noun, nominative: "amicus", stem: "amic", inflection_class: 2, sexus: :m}]
            form_builder_strings(args).should == %w(amicus amici amico amicum amice amico amici amicorum amicis amicos amici amicis)
          end

          it "builds all forms - handles vocative for ius forms properly when nominative is given" do
            args = [{type: :noun, nominative: "filius", stem: "fili", inflection_class: 2, sexus: :m}]
            form_builder_strings(args).should == %w(filius filii filio filium fili filio filii filiorum filiis filios filii filiis)
          end

          it "builds all forms - handles vocative for ius forms properly when no nominative is given" do
            args = [{type: :noun, stem: "fili", inflection_class: 2, sexus: :m}]
            form_builder_strings(args).should == %w(filius filii filio filium fili filio filii filiorum filiis filios filii filiis)
          end

          it "segmentizes fili vocative correctly" do
            args = [{type: :noun, stem: "fili", inflection_class: 2, sexus: :m}]
            forms = LLT::FormBuilder.build(*args)
            forms[4].to_s(:segmentized).should == "fili"
          end

          it "builds all forms with er ending - needs nominative given" do
            args = [{type: :noun, stem: "puer", inflection_class: 2, sexus: :m, nominative: "puer"}]
            form_builder_strings(args)[0].should == "puer"
            form_builder_strings(args)[4].should == "puer"
          end

          it "builds all forms with er ending - needs nominative given" do
            args = [{type: :noun, nominative: "magister", stem: "magistr", inflection_class: 2, sexus: :m}]
            form_builder_strings(args)[0].should == "magister"
            form_builder_strings(args)[4].should == "magister"
          end

          it "builds all forms without an ending - needs nominative given (vir)" do
            args = [{type: :noun, nominative: "vir", stem: "vir", inflection_class: 2, sexus: :m}]
            strings = form_builder_strings(args)
            strings.should have(12).items
            vir = strings.first
            vir.should == "vir"
          end
        end

        it "builds all forms of O - n" do
          args = [{type: :noun, stem: "templ", inflection_class: 2, sexus: :n}]
          form_builder_strings(args).should == %w(templum templi templo templum templum templo templa templorum templis templa templa templis)
        end

        it "builds all forms of C - m" do
          args = [{type: :noun, nominative: "homo", stem: "homin", inflection_class: 3, sexus: :m}]
          form_builder_strings(args).should == %w(homo hominis homini hominem homo homine homines hominum hominibus homines homines hominibus)
        end

        it "builds all forms of C - n" do
          args = [{type: :noun, nominative: "flumen", stem: "flumin", inflection_class: 3, sexus: :n}]
          form_builder_strings(args).should == %w(flumen fluminis flumini flumen flumen flumine flumina fluminum fluminibus flumina flumina fluminibus)
        end

        it "builds all forms of wildly irregular words like bos" do
          irregular = [["bos", 1, 1], ["boum", 2, 2], ["bubus", 3, 2], ["bubus", 6, 2]]
          additional =  [["bobus", 3, 2], ["bobus", 6, 2]]
          args = [{type: :noun, stem: "bov", inflection_class: 3, sexus: :m, irregular_forms: irregular, additional_forms: additional}]
          form_builder_strings(args).should == %w(bos bovis bovi bovem bos bove boves boum bubus boves boves bubus bobus bobus)
        end

        it "builds objects with stem and ending separated" do
          args = [{type: :noun, stem: "ros", inflection_class: 1, sexus: :f}]
          forms = LLT::FormBuilder.build(*args)
          # forms.first = all forms of the one stem it was initialized with
          rosa = forms.first
          rosa.stem.should == "ros"
          rosa.ending.should == "a"
          rosa.sexus.should == :f
        end

        it "builds objects with stem and ending separated even for irregular forms like bubus" do
          irregular = [["bos", 1, 1], ["boum", 2, 2], ["bubus", 3, 2], ["bubus", 6, 2]]
          additional =  [["bobus", 3, 2], ["bobus", 6, 2]]
          args = [{type: :noun, stem: "bov", inflection_class: 3, sexus: :m, irregular_forms: irregular, additional_forms: additional}]
          forms = LLT::FormBuilder.build(*args)
          # forms.first = all forms of the one stem it was initialized with
          bubus = forms[11] # ablative plural
          bubus.stem.should == "bu"
          bubus.ending.should == "bus"
          bubus.sexus.should == :m
        end
      end


      context "with options that select a specfic form given in a stem" do
        it "returns only forms specified in options" do
          with_noun_options(numerus: 2).should have(6).items
          with_noun_options(casus: 2).should have(2).items
          with_noun_options(numerus: 1, casus: 2).should have(1).item
        end

        it "works with irregulars as well" do
          irregular = [["bos", 1, 1], ["boum", 2, 2], ["bubus", 3, 2], ["bubus", 6, 2]]
          additional =  [["bobus", 3, 2], ["bobus", 6, 2]]
          options = { numerus: 1 }
          args = [{type: :noun, stem: "bov", inflection_class: 3, sexus: :m,
            irregular_forms: irregular, additional_forms: additional, options: options}]
          forms = LLT::FormBuilder.build(*args)
          forms.should have(6).items
        end

        context "with special nominatives" do
          it "homo" do
            options = { numerus: 1, casus: 1 }
            args = [{type: :noun, nominative: "hŏmō", stem: "hŏmĭn", inflection_class: 3, sexus: :m, options: options}]
            forms = LLT::FormBuilder.build(*args)
            forms.should have(1).item
          end

          it "magister" do
            options = { numerus: 1, casus: 1 }
            args = [{type: :noun, nominative: "magister", stem: "magistr", inflection_class: 1, sexus: :m, options: options}]
            forms = LLT::FormBuilder.build(*args)
            forms.should have(1).item
          end

          it "vir" do
            options = { numerus: 1, casus: 1 }
            args = [{type: :noun, nominative: "vir", stem: "vir", inflection_class: 2, sexus: :m, options: options}]
            forms = LLT::FormBuilder.build(*args)
            forms.should have(1).item
          end
        end

        context "with special vocatives" do
          it "fili" do
            options = { casus: 5, numerus: 1}
            args = { type: :noun, nom: "filius", stem: "fili", itype: 2, sexus: :m, options: options }
            forms = LLT::FormBuilder.build(args)
            forms.should have(1).item
            forms.first.to_s(:segmentized).should == "fili"
          end
        end
      end

      context "with a metrical stem" do
        it "builds all forms as metrical utf8 strings" do
          args = [{type: :noun, nominative: "hŏmō", stem: "hŏmĭn", inflection_class: 3, sexus: :m}]
          form_builder_strings(args).should == %w(hŏmō hŏmĭnĭs hŏmĭnī hŏmĭnĕm hŏmō hŏmĭnĕ hŏmĭnēs hŏmĭnŭm hŏmĭnĭbŭs hŏmĭnēs hŏmĭnēs hŏmĭnĭbŭs)
        end
      end

      it "initializes Word objects with inflection class" do
        args = [{type: :noun, stem: "ros", inflection_class: 1, sexus: :f}]
        forms = LLT::FormBuilder.build(*args)
        # forms.first = all forms of the one stem it was initialized with
        rosa = forms.first
        rosa.inflection_class.should == 1
      end

      it "makes use of LLT::Helpers::Normalizer" do
        args = [{type: :noun, stem: "ros", itype: 1, "gender" => :f}]
        forms = LLT::FormBuilder.build(*args)
        forms.map(&:to_s).should == %w(rosa rosae rosae rosam rosa rosa rosae rosarum rosis rosas rosae rosis)
        rosa = forms.first
        rosa.sexus.should == :f
      end

      context "with options that indicate the word's components" do
        it "builds correct forms only (one possibility)" do
          res = with_noun_options(ending: "am")
          res.should have(1).item
          res.first.casus.should == 4
          res.first.numerus.should == 1
        end

        it "builds correct forms only (several possibilities)" do
          res = with_noun_options(ending: "a")
          res.should have(3).item

          rosa_nom = res.first
          rosa_abl = res[2]

          rosa_nom.casus.should == 1
          rosa_abl.casus.should == 6
        end

        it "doesn't build incorrect forms" do
          res = with_noun_options(ending: "um")
          res.should be_empty
        end

        context "with special nominatives, where ending is an empty string" do
          it "homo" do
            options = { ending: "" }
            args = [{type: :noun, nominative: "hŏmō", stem: "hŏmĭn", inflection_class: 3, sexus: :m, options: options}]
            forms = LLT::FormBuilder.build(*args)
            forms.should have(2).items
            forms.map(&:to_s).should == %w{ hŏmō hŏmō }
          end

          it "magister" do
            options = { ending: "" }
            args = [{type: :noun, nominative: "magister", stem: "magistr", inflection_class: 2, sexus: :m, options: options}]
            forms = LLT::FormBuilder.build(*args)
            forms.should have(2).items
          end

          it "vir" do
            options = { ending: "" }
            args = [{type: :noun, nominative: "vir", stem: "vir", inflection_class: 2, sexus: :m, options: options}]
            forms = LLT::FormBuilder.build(*args)
            forms.should have(2).item
          end
        end
      end
    end
  end
end
