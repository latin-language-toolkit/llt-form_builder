require 'spec_helper'

describe LLT::FormBuilder do
  include LLT::Helpers::Normalizer

  describe ".build" do
    def form_builder_strings(args)
      forms = LLT::FormBuilder.build(*args)
      forms.map(&:to_s)
    end

    def verb_with_options(options)
      args = [{type: :praesens, stem: "ama", inflection_class: 1, options: options}]
      LLT::FormBuilder.build(*args)
    end

    def perf_verb_with_options(options)
      args = [{type: :perfectum, stem: "amav", inflection_class: 1, options: options}]
      LLT::FormBuilder.build(*args)
    end

    context "with verbs" do
      context "without options" do
        context "with praesens stem" do
          context "check variables of a single form" do
            context "a conj" do
              let(:forms) do
                args = [{type: :praesens, stem: "ama", inflection_class: 1}]
                LLT::FormBuilder.build(*args)
              end

              it "1.st.sg.ind.pr.act." do
                amo = forms[0]
                amo.modus.should == t.indicativus
                amo.genus.should == t.activum
                amo.tempus.should == t.praesens
                amo.numerus.should == t.sg
                amo.persona.should == 1
              end

              it "3.pl.ind.pr.pass." do
                amantur = forms[11]
                amantur.modus.should == t.indicativus
                amantur.genus.should == t.passivum
                amantur.tempus.should == t.praesens
                amantur.numerus.should == t.pl
                amantur.persona.should == 3
                amantur.to_s(true).should == "ama-ntur"
              end

              it "3.sg.con.pr.act." do
                amet = forms[14]
                amet.modus.should == t.con
                amet.genus.should == t.act
                amet.tempus.should == t.praesens
                amet.numerus.should == t.sg
                amet.persona.should == 3
                amet.to_s(true).should == "am-e-t"
              end

              it "2.pl.ind.imp.pass." do
                amabatis = forms[32]
                amabatis.modus.should == t.ind
                amabatis.genus.should == t.act
                amabatis.tempus.should == t.impf
                amabatis.to_s(true).should == "ama-ba-tis"
                amabatis.persona.should == 2
                amabatis.numerus.should == t.pl
              end

              it "3.pl.ind.fut.pass." do
                amabuntur = forms[63]
                amabuntur.modus.should == t.ind
                amabuntur.genus.should == t.pass
                amabuntur.tempus.should == t.fut
                amabuntur.numerus.should == t.pl
                amabuntur.persona.should == 3
                amabuntur.to_s(true).should == "ama-b-u-ntur"
              end
            end

            context "c conj" do
              let(:forms) do
                args = [{ type: :praesens, stem: "leg", inflection_class: 3 }]
                LLT::FormBuilder.build(*args)
              end

              it "1.sg.con.pr.pass." do
                legar = forms[18]
                legar.modus.should == t.con
                legar.genus.should == t.pass
                legar.tempus.should == t.pr
                legar.numerus.should == t.sg
                legar.persona.should == 1
                legar.to_s(true).should == "leg-a-r"
              end
            end

            context "i conj" do
              let(:forms) do
                args = [{ type: :praesens, stem: "audi", inflection_class: 4 }]
                LLT::FormBuilder.build(*args)
              end

              it "2.pl.con.impf.pass." do
                audiremini = forms[50]
                audiremini.modus.should == t.con
                audiremini.genus.should == t.pass
                audiremini.tempus.should == t.impf
                audiremini.numerus.should == t.pl
                audiremini.persona.should == 2
                audiremini.to_s(true).should == "audi-re-mini"
              end

              it "3.pl.ind.pr.act." do
                audiunt = forms[5]
                audiunt.modus.should == t.indicativus
                audiunt.genus.should == t.activum
                audiunt.tempus.should == t.praesens
                audiunt.numerus.should == t.pl
                audiunt.persona.should == 3
                audiunt.to_s(true).should == "audi-u-nt"
              end
            end

            context "m conj" do
              let(:forms) do
                args = [{ type: :praesens, stem: "cap", inflection_class: 5 }]
                LLT::FormBuilder.build(*args)
              end

              it "1.pl.ind.fut.act." do
                capiemus = forms[55]
                capiemus.modus.should == t.ind
                capiemus.genus.should == t.act
                capiemus.tempus.should == t.fut
                capiemus.numerus.should == t.pl
                capiemus.persona.should == 1
                capiemus.to_s(true).should == "cap-i-e-mus"
              end
            end
          end

          context "works with deponentia" do
            it "builds all forms" do
              args = [{ type: :praesens, stem: "horta", inflection_class: 1, deponens: true, options: { finite: true }}]
              forms = LLT::FormBuilder.build(*args)
              forms.should have(35).items
              forms.all? { |f| f.genus == :act }.should be_true
              forms.first.to_s.should == "hortor"
            end
          end

          context "works with impersonalia" do
            it "builds only 3rd person forms" do
              args = [{ type: :praesens, stem: "oporte", inflection_class: 2, impersonalium: true, options: { finite: true }}]
              forms = LLT::FormBuilder.build(*args)
              forms.should have(24).items
            end
          end

          context "builds all forms of" do
            it "a conj" do
              args = [{type: :praesens, stem: "ama", inflection_class: 1, options: { finite: true }}]
              form_builder_strings(args).should == %w{ amo amas amat amamus amatis amant
                                                     amor amaris amatur amamur amamini amantur
                                                     amem ames amet amemus ametis ament
                                                     amer ameris ametur amemur amemini amentur
                                                     ama amate amare amamini

                                                     amabam amabas amabat amabamus amabatis amabant
                                                     amabar amabaris amabatur amabamur amabamini amabantur
                                                     amarem amares amaret amaremus amaretis amarent
                                                     amarer amareris amaretur amaremur amaremini amarentur

                                                     amabo amabis amabit amabimus amabitis amabunt
                                                     amabor amaberis amabitur amabimur amabimini amabuntur
                                                     amato amato amatote amanto amator amator amantor }
            end

            it "e conj" do
              args = [{type: :praesens, stem: "mone", inflection_class: 2, options: { finite: true }}]
              form_builder_strings(args).should == %w{ moneo mones monet monemus monetis monent
                                                     moneor moneris monetur monemur monemini monentur
                                                     moneam moneas moneat moneamus moneatis moneant
                                                     monear monearis moneatur moneamur moneamini moneantur
                                                     mone monete monere monemini

                                                     monebam monebas monebat monebamus monebatis monebant
                                                     monebar monebaris monebatur monebamur monebamini monebantur
                                                     monerem moneres moneret moneremus moneretis monerent
                                                     monerer monereris moneretur moneremur moneremini monerentur

                                                     monebo monebis monebit monebimus monebitis monebunt
                                                     monebor moneberis monebitur monebimur monebimini monebuntur
                                                     moneto moneto monetote monento monetor monetor monentor }
            end

            it "c conj" do
              args = [{type: :praesens, stem: "leg", inflection_class: 3, options: { finite: true }}]
              form_builder_strings(args).should == %w{ lego legis legit legimus legitis legunt
                                                     legor legeris legitur legimur legimini leguntur
                                                     legam legas legat legamus legatis legant
                                                     legar legaris legatur legamur legamini legantur
                                                     lege legite legere legimini

                                                     legebam legebas legebat legebamus legebatis legebant
                                                     legebar legebaris legebatur legebamur legebamini legebantur
                                                     legerem legeres legeret legeremus legeretis legerent
                                                     legerer legereris legeretur legeremur legeremini legerentur

                                                     legam leges leget legemus legetis legent
                                                     legar legeris legetur legemur legemini legentur
                                                     legito legito legitote legunto legitor legitor leguntor }
            end

            it "i conj" do
              args = [{type: :praesens, stem: "audi", inflection_class: 4, options: { finite: true }}]
              form_builder_strings(args).should == %w{ audio audis audit audimus auditis audiunt
                                                     audior audiris auditur audimur audimini audiuntur
                                                     audiam audias audiat audiamus audiatis audiant
                                                     audiar audiaris audiatur audiamur audiamini audiantur
                                                     audi audite audire audimini

                                                     audiebam audiebas audiebat audiebamus audiebatis audiebant
                                                     audiebar audiebaris audiebatur audiebamur audiebamini audiebantur
                                                     audirem audires audiret audiremus audiretis audirent
                                                     audirer audireris audiretur audiremur audiremini audirentur

                                                     audiam audies audiet audiemus audietis audient
                                                     audiar audieris audietur audiemur audiemini audientur
                                                     audito audito auditote audiunto auditor auditor audiuntor }
            end

            it "m conj" do
              args = [{type: :praesens, stem: "cap", inflection_class: 5, options: { finite: true }}]
              form_builder_strings(args).should == %w{ capio capis capit capimus capitis capiunt
                                                     capior caperis capitur capimur capimini capiuntur
                                                     capiam capias capiat capiamus capiatis capiant
                                                     capiar capiaris capiatur capiamur capiamini capiantur
                                                     cape capite capere capimini

                                                     capiebam capiebas capiebat capiebamus capiebatis capiebant
                                                     capiebar capiebaris capiebatur capiebamur capiebamini capiebantur
                                                     caperem caperes caperet caperemus caperetis caperent
                                                     caperer capereris caperetur caperemur caperemini caperentur

                                                     capiam capies capiet capiemus capietis capient
                                                     capiar capieris capietur capiemur capiemini capientur
                                                     capito capito capitote capiunto capitor capitor capiuntor }
            end
          end
        end

        context "with praesens infinitive" do
          it "builds all forms" do
            args = [{ type: :praesens_infinitivum, stem: "ama", inflection_class: 1 }]
            forms = LLT::FormBuilder.build(*args)
            forms.should have(2).items
            a = forms.first
            p = forms.last
            a.to_s(:segmentized).should == "ama-re"
            p .to_s(:segmentized).should == "ama-ri"
            a.genus.should == :act
            p.genus.should == :pass
          end

          it "builds all forms with proper thematic" do
            args = [{ type: :praesens_infinitivum, stem: "leg", inflection_class: 3 }]
            forms = LLT::FormBuilder.build(*args)
            forms.should have(2).items
            a = forms.first
            p = forms.last
            a.to_s(:segmentized).should == "leg-e-re"
            p.to_s(:segmentized).should == "leg-i"
          end
        end

        context "with perfect stem" do
          it "builds all forms" do
            args = { type: :perfectum, stem: "amav", inflection_class: 1 }
            forms = LLT::FormBuilder.build(args)
            forms.should have(31).items
          end

          it "builds only correct forms" do
            opts = {:ending=>"t", :extension=>"isse", :validate => true}
            args = {:type=>:perfectum, :stem=>"ven", :inflection_class=>4, options: opts}
            forms = LLT::FormBuilder.build(args)
            forms.should_not be_empty
          end

          it "builds all forms - even for esse" do
            args = { type: :perfectum, stem: "fu", inflection_class: :esse }
            forms = LLT::FormBuilder.build(args)
            forms.should have(31).items
          end
        end

        context "with perfect infinitive" do
          it "builds all forms" do
            args = [{ type: :perfectum_infinitivum, stem: "amav", inflection_class: 1 }]
            forms = LLT::FormBuilder.build(*args)
            forms.should have(1).items
            a = forms.first
            a.to_s(:segmentized).should == "amav-isse"
            a.genus.should == :act
            a.tempus.should == :pf
          end
        end
      end


      context "of irregular praesens stem" do
        context "with esse" do
          it "builds all forms" do
            args = [{ type: :praesens, stem: "s", inflection_class: :esse }]
            forms = LLT::FormBuilder.build(*args)
            forms.map(&:to_s).should == %w{
              sum es est sumus estis sunt
              sim sis sit simus sitis sint
              es este
              eram eras erat eramus eratis erant
              essem esses esset essemus essetis essent
              ero eris erit erimus eritis erunt
              esto esto estote sunto
              esse
            }
          end
        end

        context "with fieri" do
          it "builds all forms" do
            args = [{ type: :praesens, stem: "fi", inflection_class: :fieri }]
            forms = LLT::FormBuilder.build(*args)
            forms.map(&:to_s).should == %w{
              fio fis fit fimus fitis fiunt
              fiam fias fiat fiamus fiatis fiant
              fiebam fiebas fiebat fiebamus fiebatis fiebant
              fierem fieres fieret fieremus fieretis fierent
              fiam fies fiet fiemus fietis fient
              fieri
            }
          end
        end

        context "with malle" do
          it "builds all forms" do
            args = [{ type: :praesens, stem: "mal", inflection_class: :malle }]
            forms = LLT::FormBuilder.build(*args)
            forms.map(&:to_s).should == %w{
              malo mavis mavult malumus mavultis malunt
              malim malis malit malimus malitis malint
              malebam malebas malebat malebamus malebatis malebant
              mallem malles mallet mallemus malletis mallent
              malam males malet malemus maletis malent
              malle
            }
          end
        end

        context "with velle" do
          it "builds all forms" do
            args = [{ type: :praesens, stem: "vol", inflection_class: :velle }]
            forms = LLT::FormBuilder.build(*args)
            forms.map(&:to_s).should == %w{
              volo vis vult volumus vultis volunt
              velim velis velit velimus velitis velint
              volebam volebas volebat volebamus volebatis volebant
              vellem velles vellet vellemus velletis vellent
              volam voles volet volemus voletis volent
              velle
            }
          end
        end

        context "with posse" do
          it "builds all forms" do
            args = [{ type: :praesens, stem: "pot", inflection_class: :posse }]
            forms = LLT::FormBuilder.build(*args)
            forms.map(&:to_s).should == %w{
              possum potes potest possumus potestis possunt
              possim possis possit possimus possitis possint
              poteram poteras poterat poteramus poteratis poterant
              possem posses posset possemus possetis possent
              potero poteris poterit poterimus poteritis poterunt
              posse
            }
          end
        end

        context "with ire" do
          it "builds all forms" do
            args = [{ type: :praesens, stem: "i", inflection_class: :ire }]
            forms = LLT::FormBuilder.build(*args)
            forms.map(&:to_s).should == %w{
              eo is it imus itis eunt
              eor iris itur imur imini euntur
              eam eas eat eamus eatis eant
              ear earis eatur eamur eamini eantur
              i ite ire imini

              ibam ibas ibat ibamus ibatis ibant
              ibar ibaris ibatur ibamur ibamini ibantur
              irem ires iret iremus iretis irent
              irer ireris iretur iremur iremini irentur
              ibo ibis ibit ibimus ibitis ibunt
              ibor iberis ibitur ibimur ibimini ibuntur
              ito ito itote eunto itor itor euntor
              ire iri

              iens euntis eunti euntem iens eunte
              euntes euntium euntibus euntes euntes euntibus
              iens euntis eunti euntem iens eunte
              euntes euntium euntibus euntes euntes euntibus
              iens euntis eunti iens iens eunte
              euntia euntium euntibus euntia euntia euntibus

              eundi eundo eundum eundo

              eundus eundi eundo eundum eunde eundo
              eundi eundorum eundis eundos eundi eundis
              eunda eundae eundae eundam eunda eunda
              eundae eundarum eundis eundas eundae eundis
              eundum eundi eundo eundum eundum eundo
              eunda eundorum eundis eunda eunda eundis
            }
          end
        end

        context "with ferre" do
          it "builds all forms" do
            args = [{ type: :praesens, stem: "fer", inflection_class: :ferre }]
            forms = LLT::FormBuilder.build(*args)
            forms.map(&:to_s).should == %w{
              fero fers fert ferimus fertis ferunt
              feror ferris fertur ferimur ferimini feruntur
              feram feras ferat feramus feratis ferant
              ferar feraris feratur feramur feramini ferantur

              fer ferte ferre ferimini
              ferebam ferebas ferebat ferebamus ferebatis ferebant
              ferebar ferebaris ferebatur ferebamur ferebamini ferebantur
              ferrem ferres ferret ferremus ferretis ferrent
              ferrer ferreris ferretur ferremur ferremini ferrentur
              feram feres feret feremus feretis ferent
              ferar fereris feretur feremur feremini ferentur
              ferto ferto fertote ferunto fertor fertor feruntor
              ferre ferri

              ferens ferentis ferenti ferentem ferens ferente
              ferentes ferentium ferentibus ferentes ferentes ferentibus
              ferens ferentis ferenti ferentem ferens ferente
              ferentes ferentium ferentibus ferentes ferentes ferentibus
              ferens ferentis ferenti ferens ferens ferente
              ferentia ferentium ferentibus ferentia ferentia ferentibus

              ferendi ferendo ferendum ferendo

              ferendus ferendi ferendo ferendum ferende ferendo
              ferendi ferendorum ferendis ferendos ferendi ferendis
              ferenda ferendae ferendae ferendam ferenda ferenda
              ferendae ferendarum ferendis ferendas ferendae ferendis
              ferendum ferendi ferendo ferendum ferendum ferendo
              ferenda ferendorum ferendis ferenda ferenda ferendis
            }
          end

        end
      end

      context "with options that select a specfic form given in a stem" do
        context "of praesens stem" do
          context "only forms specified in options" do
            it "returns pr" do
              opts = { tempus: :pr }
              forms = verb_with_options(opts)
              forms.should have(28).items
            end

            it "returns impf" do
              opts = { tempus: :impf }
              forms = verb_with_options(opts)
              forms.should have(24).items
            end
          end
        end

        context "of perfect stem" do
          context "only forms specified in options" do
            it "returns pqpf" do
              opts = { tempus: :pqpf }
              forms = perf_verb_with_options(opts)
              forms.should have(12).items
            end

            it "returns pf con" do
              opts = { tempus: :pf, modus: :con }
              forms = perf_verb_with_options(opts)
              forms.should have(6).items
            end

            context "impossible forms" do
              it "returns pf pass" do
                opts = { tempus: :pf, genus: :pass }
                forms = perf_verb_with_options(opts)
                forms.should have(0).items
              end
            end
          end
         end
      end

      context "with options that indicate the word's components" do
        context "of praesens stem" do
          context "with validate flag passed" do
            it "builds only correct forms when extension is given" do
              opts = { extension: "re", validate: true }
              forms = verb_with_options(opts)
              forms.should have(12).items
              forms.all? { |f| f.tempus == :impf }.should be_true
            end

            it "builds only correct forms when ending is given" do
              opts = { ending: "nt" }
              forms = verb_with_options(opts)
              forms.should have(5).items
            end

            it "buils only correct forms when ending is given - deponentia" do
              opts = { ending: "s", validate: true}
              args = { type: :praesens, stem: "causa", inflection_class: 1, deponens: true, options: opts }
              forms = LLT::FormBuilder.build(args)
              forms.should be_empty
            end

            it "returns pr con" do
              opts = { tempus: :pr, modus: :con }
              forms = verb_with_options(opts)
              forms.should have(12).items
            end
          end

          context "of irregular praesens stem" do
            it "build only correct forms" do
              opts = { prefix: "", stem: "s", thematic: "u", extension: "", ending: "nt", validate: true }
              arg  = { type: :praesens, inflection_class: :esse, options: opts }
              forms = LLT::FormBuilder.build(arg)
              forms.should have(1).item
              forms.first.to_s(:segmentized).should == "s-u-nt"
            end
          end
        end
      end
    end
  end
end
