require 'spec_helper'

describe LLT::FormBuilder do
  include LLT::Helpers::Normalizer

  describe ".build" do
    def form_builder_strings(args)
      forms = LLT::FormBuilder.build(*args)
      forms.map(&:to_s)
    end

    def with_ppa(options)
      args = [{type: :ppa, stem: "ama", inflection_class: 1, options: options}]
      LLT::FormBuilder.build(*args)
    end

    context "with ppas" do
      context "build all forms" do
        it "a conj" do
          args = [{type: :ppa, stem: "ama", inflection_class: 1, tense: :pr}]
          form_builder_strings(args).should == %w{ amans amantis amanti amantem amans amante amantes amantium amantibus amantes amantes amantibus
                                                   amans amantis amanti amantem amans amante amantes amantium amantibus amantes amantes amantibus
                                                   amans amantis amanti amans amans amante amantia amantium amantibus amantia amantia amantibus }
        end

        it "e conj" do
          args = [{type: :ppa, stem: "mone", inflection_class: 2, tense: :pr}]
          form_builder_strings(args).should == %w{ monens monentis monenti monentem monens monente monentes monentium monentibus monentes monentes monentibus
                                                   monens monentis monenti monentem monens monente monentes monentium monentibus monentes monentes monentibus
                                                   monens monentis monenti monens monens monente monentia monentium monentibus monentia monentia monentibus }
        end

        it "c conj" do
          args = [{type: :ppa, stem: "leg", inflection_class: 3, tense: :pr}]
          form_builder_strings(args).should == %w{ legens legentis legenti legentem legens legente legentes legentium legentibus legentes legentes legentibus
                                                   legens legentis legenti legentem legens legente legentes legentium legentibus legentes legentes legentibus
                                                   legens legentis legenti legens legens legente legentia legentium legentibus legentia legentia legentibus }
        end

        it "i conj" do
          args = [{type: :ppa, stem: "audi", inflection_class: 4, tense: :pr}]
          form_builder_strings(args).should == %w{ audiens audientis audienti audientem audiens audiente audientes audientium audientibus audientes audientes audientibus
                                                   audiens audientis audienti audientem audiens audiente audientes audientium audientibus audientes audientes audientibus
                                                   audiens audientis audienti audiens audiens audiente audientia audientium audientibus audientia audientia audientibus }
        end

        it "m conj" do
          args = [{type: :ppa, stem: "cap", inflection_class: 5, tense: :pr}]
          form_builder_strings(args).should == %w{ capiens capientis capienti capientem capiens capiente capientes capientium capientibus capientes capientes capientibus
                                                   capiens capientis capienti capientem capiens capiente capientes capientium capientibus capientes capientes capientibus
                                                   capiens capientis capienti capiens capiens capiente capientia capientium capientibus capientia capientia capientibus }
        end
      end

      context "with options that select a specfic form given in a stem" do
      end

      context "with options that indicate the word's components" do
        context "builds correct forms only" do

          it "amantis" do
            res = with_ppa(ending: "is", ppa_fp_or_gerund: "nt")
            res.should have(3).items
            amantis1, amantis2, amantis3 = res
            amantis1.sexus.should == :m
            amantis2.sexus.should == :f
            amantis3.sexus.should == :n

            amantis1.modus.should == t.participium
            amantis1.tempus.should == t.praesens

            amantis1.stem.should == "ama"
            amantis1.ending.should == "is"
            amantis1.to_s.should == "amantis"
            amantis1.to_s(:segmentized).should == "ama-nt-is"
          end

          context "with validate flag" do
            it "ama-nt-is" do
              options = { ending: "is", extension: "nt", validate: true }
              args = [{type: :ppa, stem: "ama", inflection_class: 1, tense: :pr, options: options}]
              forms = LLT::FormBuilder.build(*args)
              forms.should have(3).items
            end

            context "wrong forms" do
              it "ama-nt-is - no extension given" do
                options = { ending: "is", validate: true }
                args = [{type: :ppa, stem: "ama", inflection_class: 1, tense: :pr, options: options}]
                forms = LLT::FormBuilder.build(*args)
                forms.should have(0).items
              end

              it "*cap-e-nt-is" do
                options = { thematic: "e", validate: true }
                args = [{type: :ppa, stem: "cap", inflection_class: 5, tense: :pr, options: options}]
                forms = LLT::FormBuilder.build(*args)
                forms.should be_empty
              end

              it "*cap-nt-is" do
                options = { ending: "is", validate: true }
                args = [{type: :ppa, stem: "cap", inflection_class: 5, tense: :pr, options: options}]
                forms = LLT::FormBuilder.build(*args)
                forms.should be_empty
              end

              it "*ama-e-nt-is" do
                options = { ending: "is", thematic: "e", validate: true }
                args = [{type: :ppa, stem: "ama", inflection_class: 1, tense: :pr, options: options}]
                forms = LLT::FormBuilder.build(*args)
                forms.should be_empty
              end

              it "*aud-ie-nt-is" do
                options = { ending: "is", thematic: "ie", validate: true }
                args = [{type: :ppa, stem: "aud", inflection_class: 1, tense: :pr, options: options}]
                forms = LLT::FormBuilder.build(*args)
                forms.should be_empty
              end
            end
          end

          it "audi-e-nt-is" do
            options = { ending: "is", thematic: "e" }
            args = [{type: :ppa, stem: "audi", inflection_class: 4, tense: :pr, options: options}]
            forms = LLT::FormBuilder.build(*args)
            forms.should have(3).items
            forms.first.to_s.should == "audientis"
            forms.first.to_s(:segmentized).should == "audi-e-nt-is"
          end
        end
      end

    end
  end
end
