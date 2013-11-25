require 'spec_helper'

describe LLT::FormBuilder::StemHashParser do
  def shp(arg)
    LLT::FormBuilder::StemHashParser.new(arg)
  end

  include LLT::Helpers::Normalizer

  describe "#parse" do
    context "with praesens" do
      it "changes type to gerund and gerundive with options extensions: 'nd'" do
        args = [{type: :praesens, stem: "ama", inflection_class: 1, options: { extension: "nd" }}]
        shp(args).parse.should =~ [{type: :gerund, stem: "ama", inflection_class: 1, options: { extension: "nd" }},
                                   {type: :gerundive, stem: "ama", inflection_class: 1, options: { extension: "nd" }} ]
      end

      it "changes type to gerund with options modus: 'gerund'" do
        args = [{type: :praesens, stem: "ama", inflection_class: 1, options: { modus: "gerund" }}]
        shp(args).parse.should =~ [{type: :gerund, stem: "ama", inflection_class: 1, options: { modus: :gerundium }}]
      end

      it "changes type to gerundive with options modus: 'gerundive'" do
        args = [{type: :praesens, stem: "ama", inflection_class: 1, options: { modus: "gerundive" }}]
        shp(args).parse.should =~ [{type: :gerundive, stem: "ama", inflection_class: 1, options: { modus: :gerundivum }}]
      end

      it "changes type to ppa with options extension: 'nt' or 'n'" do
        args = [{type: :praesens, stem: "ama", inflection_class: 1, options: { extension: "n" }}]
        shp(args).parse.should =~ [{type: :ppa, stem: "ama", inflection_class: 1, options: { extension: "n" }}]
      end

      it "changes type to ppa with options modus: 'participle'" do
        args = [{type: :praesens, stem: "ama", inflection_class: 1, options: { modus: :participium }}]
        shp(args).parse.should =~ [{type: :ppa, stem: "ama", inflection_class: 1, options: { modus: :part }}]
      end

      it "changes type to ppa with options modus: 'infinitive'" do
        args = [{type: :praesens, stem: "ama", inflection_class: 1, options: { modus: :infinitive }}]
        shp(args).parse.should =~ [{type: :praesens_infinitivum, stem: "ama", inflection_class: 1, options: { modus: :inf }}]
      end

      it "returns hashes of the types praesens praesens_infinitivum ppa gerund gerundive without options" do
        args = [{type: :praesens, stem: "ama", inflection_class: 1}]
        shp(args).parse.map { |h| h[:type] }.should =~ %i{ praesens praesens_infinitivum ppa gerund gerundive }
      end

      context "confronted with irregulars" do
        it "returns irregular prasens and no verbal nouns for esse" do
          args = [{type: :praesens, inflection_class: :esse}]
          shp(args).parse.map { |h| h[:type] }.should =~ %i{ irregular_praesens irregular_praesens_infinitivum }
        end

        it "returns irregular prasens and no verbal nouns for esse" do
          opts = {:stem=>"es", :ending=>"se"}
          args = [{type: :praesens, inflection_class: :esse, options: opts}]
          shp(args).parse.map { |h| h[:type] }.should =~ %i{ irregular_praesens irregular_praesens_infinitivum }
        end


        it "handles options with ease for irregulars" do
          opts = { ending: "nt", thematic: "u", stem: "s", prefix: "", extension: "" }
          args = [{type: :praesens, inflection_class: :esse, options: opts}]
          shp(args).parse.map { |h| h[:type] }.should =~ %i{ irregular_praesens }
        end

        it "returns irregular prasens and no verbal nouns for fieri" do
          args = [{type: :praesens, inflection_class: :fieri}]
          shp(args).parse.map { |h| h[:type] }.should =~ %i{ irregular_praesens irregular_praesens_infinitivum }
        end

        it "returns irregular prasens and no verbal nouns for velle" do
          args = [{type: :praesens, inflection_class: :velle}]
          shp(args).parse.map { |h| h[:type] }.should =~ %i{ irregular_praesens irregular_praesens_infinitivum }
        end

        it "returns irregular prasens and no verbal nouns for malle" do
          args = [{type: :praesens, inflection_class: :malle}]
          shp(args).parse.map { |h| h[:type] }.should =~ %i{ irregular_praesens irregular_praesens_infinitivum }
        end

        it "returns irregular prasens and no verbal nouns for edere" do
          args = [{type: :praesens, inflection_class: :edere}]
          shp(args).parse.map { |h| h[:type] }.should =~ %i{ irregular_praesens irregular_praesens_infinitivum }
        end

        it "returns irregular prasens and nouns for ferre" do
          args = [{type: :praesens, inflection_class: :ferre}]
          shp(args).parse.map { |h| h[:type] }.should =~ %i{ irregular_praesens irregular_praesens_infinitivum ppa gerund gerundive }
        end

        it "returns irregular prasens and verbal nouns for ire" do
          args = [{type: :praesens, inflection_class: :ire}]
          shp(args).parse.map { |h| h[:type] }.should =~ %i{ irregular_praesens irregular_praesens_infinitivum irregular_ppa irregular_gerund irregular_gerundive }
        end

        it "returns irregular prasens and no verbal nouns for posse" do
          args = [{type: :praesens, inflection_class: :posse}]
          shp(args).parse.map { |h| h[:type] }.should =~ %i{ irregular_praesens irregular_praesens_infinitivum }
        end
      end
    end

    context "with perfectum" do
      it "changes type to perfectum_infinitivum with options modus: 'infinitive'" do
        args = [{type: :perfectum, stem: "amav", inflection_class: 1, options: { modus: :infinitive }}]
        shp(args).parse.should =~ [{type: :perfectum_infinitivum, stem: "amav", inflection_class: 1, options: { modus: :inf }}]
      end

      it "returns perfectum and perfectum_infinitivum without options" do
        args = [{type: :perfectum, stem: "amav", inflection_class: 1 }]
        shp(args).parse.should =~ [{type: :perfectum, stem: "amav", inflection_class: 1},
                                   {type: :perfectum_infinitivum, stem: "amav", inflection_class: 1}]
      end

      it "returns perfectum with detailed options like venisset has" do
        opts = {:ending=>"t", :extension=>"isse", :validate => true}
        args = [{:type=>:perfectum, :stem=>"ven", :inflection_class=>4, options: opts}]
        shp(args).parse.should =~ [{type: :perfectum, stem: "ven", inflection_class: 4, options: opts}]
      end
    end

    context "with ppp" do
      it "changes type to fp with options extensions: 'ur'" do
        args = [{type: :ppp, stem: "amat", inflection_class: 1, options: { extension: "ur" }}]
        shp(args).parse.should =~ [{type: :fp, stem: "amat", inflection_class: 1, options: { extension: "ur" }}]
      end

      it "changes type to ... with options modus: 'participle'" do
        args = [{type: :ppp, stem: "amat", inflection_class: 1, options: { modus: :participium }}]
        shp(args).parse.should =~ [{type: :ppp, stem: "amat", inflection_class: 1, options: { modus: :part }},
                                   {type: :fp,  stem: "amat", inflection_class: 1, options: { modus: :part }} ]
      end

      it "changes type supinum with options modus: 'supinum'" do
        args = [{type: :ppp, stem: "amat", inflection_class: 1, options: { modus: :supinum }}]
        shp(args).parse.should =~ [{type: :supinum,  stem: "amat", inflection_class: 1, options: { modus: :supinum } }]
      end

      it "returns ppp, fp and supinum without options" do
        args = [{type: :ppp, stem: "amat", inflection_class: 1}]
        shp(args).parse.should =~ [{type: :ppp, stem: "amat", inflection_class: 1 },
                                   {type: :fp,  stem: "amat", inflection_class: 1 },
                                   {type: :supinum,  stem: "amat", inflection_class: 1 }]
      end
    end

    context "with adjectives" do
      it "returns adjective and adverb stems" do
        args = [{type: :adjective, stem: "alt", inflection_class: 1, comparatio: :positivus}]
        shp(args).parse.should =~ [ {type: :adjective, stem: "alt", inflection_class: 1, comparatio: :positivus},
                                    {type: :adverb, stem: "alt", inflection_class: 1, comparatio: :positivus}]
      end

      it "corrects the comparativus stem" do
        args = [{type: :adjective, stem: "altior", inflection_class: 1, comparatio: :comparativus}]
        shp(args).parse.should =~ [ {type: :adjective, stem: "altior", inflection_class: 1, comparatio: :comparativus},
                                    {type: :adverb, stem: "altius", inflection_class: 1, comparatio: :comparativus}]

      end

      it "returns only adjecive stem when irregular adverb building is present" do
        args = [{type: :adjective, stem: "bon", inflection_class: 1, comparatio: :positivus, irregular_adverb: true}]
        shp(args).parse.should =~ [ {type: :adjective, stem: "bon", inflection_class: 1, comparatio: :positivus, irregular_adverb: true} ]
      end
    end

    context "with pronouns" do
      context "with quisque" do
        it "returns substantivic AND adjectivic stem, when options come with ending is" do
          args = [{type: :pronoun, inflection_class: :quisque, options: { ending: "is"} }]
          stems = shp(args).parse
          stems.should have(2).items
          stems.map { |st| st[:inflection_class] }.should == %i{ quisque quisque_s  }

          args = [{type: :pronoun, inflection_class: :quisque_s, options: { ending: "is"} }]
          stems = shp(args).parse
          stems.should have(2).items
          stems.map { |st| st[:inflection_class] }.should == %i{ quisque quisque_s  }
        end
      end
    end

    context "with unusquisque" do
      it "works like quisque" do
        args = [{type: :pronoun, inflection_class: :unusquisque, options: { ending: "is"} }]
        stems = shp(args).parse
        stems.should have(2).items
        stems.map { |st| st[:inflection_class] }.should == %i{ unusquisque unusquisque_s  }

        args = [{type: :pronoun, inflection_class: :unusquisque_s, options: { ending: "is"} }]
        stems = shp(args).parse
        stems.should have(2).items
      end
    end
  end
end
