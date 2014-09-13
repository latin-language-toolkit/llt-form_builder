require 'spec_helper'

describe LLT::FormBuilder do
  include LLT::Helpers::Normalizer

  describe ".build" do
    def form_builder_strings(args)
      forms = LLT::FormBuilder.build(*args)
      forms.map(&:to_s)
    end

    def with_adjective(options)
      args = [{type: :adjective, nominative: "atrox", stem: "atroc", inflection_class: 33,
        number_of_endings: 1, comparatio: :positivus, options: options}]
      LLT::FormBuilder.build(*args)
    end

    context "with adjectives" do
      context "without options" do
        it "builds all forms of A/O" do
          args = [{type: :adjective, stem: "amic", inflection_class: 1, number_of_endings: 3, comparatio: :positivus}]
          form_builder_strings(args).should == %w{amicus amici amico amicum amice amico amici amicorum amicis amicos amici amicis
                                                  amica amicae amicae amicam amica amica amicae amicarum amicis amicas amicae amicis
                                                  amicum amici amico amicum amicum amico amica amicorum amicis amica amica amicis
                                                  amice}
        end

        it "gets casus, numerus and sexus right" do
          args = [{type: :adjective, stem: "amic", inflection_class: 1, number_of_endings: 3, comparatio: :positivus}]
          forms = LLT::FormBuilder.build(*args)
          amicus  = forms[ 0]
          amico   = forms[ 5]
          amicam  = forms[15]
          amica_n = forms[30]

          amicus.casus.should == 1
          amicus.numerus.should == 1
          amicus.sexus.should == :m
          amicus.inflection_class.should == 1

          amico.casus.should == 6
          amico.numerus.should == 1
          amico.sexus.should == :m

          amicam.casus.should == 4
          amicam.numerus.should == 1
          amicam.sexus.should == :f

          amica_n.casus.should == 1
          amica_n.numerus.should == 2
          amica_n.sexus.should == :n
        end

        it "builds all forms of A/O like pulcher" do
          args = [{type: :adjective, nominative: "pulcher", stem: "pulchr", inflection_class: 1, number_of_endings: 3, comparatio: :positivus}]
          forms = LLT::FormBuilder.build(*args)
          forms.map(&:to_s).should ==         %w{pulcher pulchri pulchro pulchrum pulcher pulchro pulchri pulchrorum pulchris pulchros pulchri pulchris
                                                 pulchra pulchrae pulchrae pulchram pulchra pulchra pulchrae pulchrarum pulchris pulchras pulchrae pulchris
                                                 pulchrum pulchri pulchro pulchrum pulchrum pulchro pulchra pulchrorum pulchris pulchra pulchra pulchris
                                                 pulchre}
        end

        it "builds all forms of A/O like altus"  do
          args = [{type: :adjective, nominative: "altus", stem: "alt", inflection_class: 1, number_of_endings: 3, comparatio: :positivus}]
          forms = LLT::FormBuilder.build(*args)
          altus = forms[0]

          altus.casus.should == 1
          altus.numerus.should == 1
          altus.sexus.should == :m
          altus.inflection_class.should == 1
        end

        it "builds all forms of Third with 1 endings" do
          args = [{type: :adjective, nominative: "atrox", stem: "atroc", inflection_class: 33, number_of_endings: 1, comparatio: :positivus}]
          form_builder_strings(args).should == %w{atrox atrocis atroci atrocem atrox atroci atroces atrocium atrocibus atroces atroces atrocibus
                                                  atrox atrocis atroci atrocem atrox atroci atroces atrocium atrocibus atroces atroces atrocibus
                                                  atrox atrocis atroci atrox atrox atroci atrocia atrocium atrocibus atrocia atrocia atrocibus
                                                  atrociter}
        end

        it "builds all forms of Third with 2 endings" do
          args = [{type: :adjective, nominative: "facilis", stem: "facil", inflection_class: 33, number_of_endings: 2, comparatio: :positivus}]
          form_builder_strings(args).should == %w{facilis facilis facili facilem facilis facili faciles facilium facilibus faciles faciles facilibus
                                                  facilis facilis facili facilem facilis facili faciles facilium facilibus faciles faciles facilibus
                                                  facile facilis facili facile facile facili facilia facilium facilibus facilia facilia facilibus
                                                  facile}
        end

        it "builds all forms of Third with 3 endings" do
          args = [{type: :adjective, nominative: "celer", stem: "celer", inflection_class: 33, number_of_endings: 3, comparatio: :positivus}]
          form_builder_strings(args).should == %w{celer celeris celeri celerem celer celeri celeres celerium celeribus celeres celeres celeribus
                                                  celeris celeris celeri celerem celeris celeri celeres celerium celeribus celeres celeres celeribus
                                                  celere celeris celeri celere celere celeri celeria celerium celeribus celeria celeria celeribus
                                                  celeriter}
        end

        it "builds all forms of Third consonantic like vetus with 1 ending" do
          args = [{type: :adjective, nominative: "vetus", stem: "veter", inflection_class: 3, number_of_endings: 1, comparatio: :positivus}]
          form_builder_strings(args).should == %w{vetus veteris veteri veterem vetus vetere veteres veterum veteribus veteres veteres veteribus
                                                  vetus veteris veteri veterem vetus vetere veteres veterum veteribus veteres veteres veteribus
                                                  vetus veteris veteri vetus vetus vetere vetera veterum veteribus vetera vetera veteribus
                                                  veteriter}
        end

        it "builds all forms of Pronominal" do
          args = [{type: :adjective, nominative: "totus", stem: "tot", inflection_class: 5, number_of_endings: 3, comparatio: :positivus}]
          form_builder_strings(args).should == %w{totus totius toti totum tote toto toti totorum totis totos toti totis
                                                  tota totius toti totam tota tota totae totarum totis totas totae totis
                                                  totum totius toti totum totum toto tota totorum totis tota tota totis
                                                  tote} # is tote even a form?
        end

        it "builds all forms of comparativus stems" do
          args = [{type: :adjective, stem: "altior", inflection_class: 1, number_of_endings: 3, comparatio: :comparativus}]
          form_builder_strings(args).should == %w{altior altioris altiori altiorem altior altiore altiores altiorum altioribus altiores altiores altioribus
                                                  altior altioris altiori altiorem altior altiore altiores altiorum altioribus altiores altiores altioribus
                                                  altius altioris altiori altius altius altiore altiora altiorum altioribus altiora altiora altioribus
                                                  altius}
        end

        it "knows the comparison sign for comparatives" do
          args = [{type: :adjective, stem: "altior", inflection_class: 1, number_of_endings: 3, comparatio: :comparativus}]
          forms = LLT::FormBuilder.build(*args)
          altioris = forms[1]
          altioris.comparison_sign.should == "ior"
        end

        it "buids all forms of superlativus stems" do
          args = [{type: :adjective, stem: "altissim", inflection_class: 1, number_of_endings: 3, comparatio: :superlativus}]
          form_builder_strings(args).should == %w{altissimus altissimi altissimo altissimum altissime altissimo altissimi altissimorum altissimis altissimos altissimi altissimis
                                                  altissima altissimae altissimae altissimam altissima altissima altissimae altissimarum altissimis altissimas altissimae altissimis
                                                  altissimum altissimi altissimo altissimum altissimum altissimo altissima altissimorum altissimis altissima altissima altissimis
                                                  altissime}
        end

        it "knows the comparison sign for superlatives" do
          args = [{type: :adjective, stem: "altissim", inflection_class: 1, number_of_endings: 3, comparatio: :superlativus}]
          forms = LLT::FormBuilder.build(*args)
          altissimi = forms[1]
          altissimi.comparison_sign.should == "issim"
        end

        it "handles metrical stems" do
          args = [{type: :adjective, stem: "altīssīm", inflection_class: 1, number_of_endings: 3, comparatio: :superlativus}]
          forms = LLT::FormBuilder.build(*args)
          altissimi = forms[1]
          altissimi.comparison_sign.should == "īssīm"
        end
      end

      context "with options that select a specfic form given in a stem" do
        it "returns only forms specified in options" do
          options = { sexus: :f }
          res = with_adjective(options)
          res.should have(12).items
        end
      end

      context "with options that indicate the word's components" do
        it "builds correct forms only (several possibilities)" do
          res  = with_adjective(ending: "is")
          res2 = with_adjective(ending: "ibus")
          res .should have(3).items
          res2.should have(6).items
        end

        it "builds correct forms only with nominative" do
          res  = with_adjective(ending: "")
          res.should have(7).items
        end

        it "doesn't build incorrect forms" do
          res = with_adjective(ending: "orum")
          res.should be_empty
        end

        it "builds correct forms of improviso" do
          opts = { ending: "o", validate: true }
          args = {type: :adjective, stem: "improvis", nom: "improvisus", inflection_class: 1, noe: 3, comparatio: :positivus, options: opts}
          LLT::FormBuilder.build(args).should have(4).item
        end

        it "builds correct forms of noster" do
          opts = { ending: "", validate: true }
          args = { type: :adjective, stem: "nostr", nom: "noster", inflection_class: 1, noe: 3, comparatio: :positivus, options: opts}
          forms = LLT::FormBuilder.build(args)
          forms.should have(2).items
          nom, voc = forms
          nom.casus.should == 1
          voc.casus.should == 5
        end

        it "builds correct forms of laete (vocative and adverb)" do
          opts = { ending: "e", validate: true }
          args = { type: :adjective, nom: "laetus", stem: "laet", inflection_class: 1, number_of_endings: 3, options: opts }
          forms = LLT::FormBuilder.build(args)
          forms.should have(2).items
        end
      end
    end
  end
end
