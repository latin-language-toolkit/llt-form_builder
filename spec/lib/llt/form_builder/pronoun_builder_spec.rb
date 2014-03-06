require 'spec_helper'

describe LLT::FormBuilder do
  def form_builder_strings(args)
    forms = LLT::FormBuilder.build(*args)
    forms.map(&:to_s)
  end

  context "with hic" do
    it "builds all forms" do
      args = [{type: :pronoun, inflection_class: :hic}]
      form_builder_strings(args).should == %w{ hic huius huic hunc hoc hi horum his hos his
                                               haec huius huic hanc hac hae harum his has his
                                               hoc huius huic hoc hoc haec horum his haec his }
    end

    it "can build specified forms only" do
      args = {type: :pronoun, inflection_class: :hic, options: { casus: 4 }}
      forms = LLT::FormBuilder.build(args)
      forms.should have(6).items
      forms.first.casus.should == 4
    end

    it "prints particles as distinct segment" do
      args = {type: :pronoun, inflection_class: :hic, options: { casus: 4, numerus: 1, sexus: :m }}
      forms = LLT::FormBuilder.build(args)
      forms.should have(1).item
      forms.first.to_s(:segmentized).should == "h-un-c"
    end

    it "works with morphologizer style options" do
      args = {type: :pronoun, inflection_class: :hic, options: { ending: "is" }}
      forms = LLT::FormBuilder.build(args)
      forms.should have(6).item
    end
  end

  context "with ille" do
    it "builds all forms" do
      args = [{type: :pronoun, inflection_class: :ille}]
      form_builder_strings(args).should == %w{ ille illius illi illum illo illi illorum illis illos illis
                                               illa illius illi illam illa illae illarum illis illas illis
                                               illud illius illi illud illo illa illorum illis illa illis }
    end
  end

  context "with iste" do
    it "builds all forms" do
      args = [{type: :pronoun, inflection_class: :iste}]
      form_builder_strings(args).should == %w{ iste istius isti istum isto isti istorum istis istos istis
                                               ista istius isti istam ista istae istarum istis istas istis
                                               istud istius isti istud isto ista istorum istis ista istis }
    end
  end

  context "with ipse" do
    it "builds all forms" do
      args = [{type: :pronoun, inflection_class: :ipse}]
      form_builder_strings(args).should == %w{ ipse ipsius ipsi ipsum ipso ipsi ipsorum ipsis ipsos ipsis
                                               ipsa ipsius ipsi ipsam ipsa ipsae ipsarum ipsis ipsas ipsis
                                               ipsum ipsius ipsi ipsum ipso ipsa ipsorum ipsis ipsa ipsis }
    end
  end

  context "with qui" do
    it "builds all forms" do
      args = [{type: :pronoun, inflection_class: :qui}]
      form_builder_strings(args).should == %w{ qui cuius cui quem quo quocum qui quorum quibus quos quibus quibuscum
                                               quae cuius cui quam qua quacum quae quarum quibus quas quibus quibuscum
                                               quod cuius cui quod quo quocum quae quorum quibus quae quibus quibuscum }
    end

    it "builds only correct forms - qua" do
      opts = { stem: "qu", ending: "a", validate: true}
      args = {type: :pronoun, inflection_class: :qui, options: opts}
      forms = LLT::FormBuilder.build(args)
      forms.should have(1).item
      qua = forms.first
      qua.to_s(:segmentized).should == "qu-a"
      qua.casus.should == 6
      qua.numerus.should == 1
      qua.sexus.should == :f
    end

    it "builds only correct forms - quibuscum" do
      opts = { stem: "qu", ending: "ibus", suffix: "cum", validate: true}
      args = {type: :pronoun, inflection_class: :qui, options: opts}
      forms = LLT::FormBuilder.build(args)
      forms.should have(3).item
      forms.map(&:casus).should == [6] * 3
      forms.map(&:numerus).should == [2] * 3
      forms.map(&:sexus).should == %i{ m f n }
      forms.map { |f| f.to_s(:segmentized) }.should == %w{ qu-ibus-cum } * 3
    end
  end

  context "with quisquam" do
    context "with options" do
      it "builds only correct forms" do
        opts = { stem: "qu", ending: "ic", particle: "quam" }
        args = { type: :pronoun, inflection_class: :quisquam, options: opts}
        forms = LLT::FormBuilder.build(args)
        forms.should have(2).items
        forms.map { |f| f.to_s(true) }.should == %w{ qu-ic-quam } * 2
      end
    end
  end

  context "with quisquis" do
    context "with options" do
      it "builds only correct forms" do
        opts = { stem: "qu", ending: "ic", particle: "quid" }
        args = { type: :pronoun, inflection_class: :quisquis, options: opts}
        forms = LLT::FormBuilder.build(args)
        forms.should have(2).items
        forms.map { |f| f.to_s(true) }.should == %w{ qu-ic-quid } * 2
      end
    end
  end

  context "with aliqui" do
    it "builds all forms" do
      args = [{type: :pronoun, inflection_class: :aliqui}]
      form_builder_strings(args).should == %w{ aliqui alicuius alicui aliquem aliquo aliqui aliquorum aliquibus aliquos aliquibus
                                               aliqua alicuius alicui aliquam aliqua aliquae aliquarum aliquibus aliquas aliquibus
                                               aliquod alicuius alicui aliquod aliquo aliquae aliquorum aliquibus aliquae aliquibus }
    end
  end

  context "with quicumque" do
    it "builds all forms" do
      args = [{type: :pronoun, inflection_class: :quicumque}]
      form_builder_strings(args).should == %w{ quicumque cuiuscumque cuicumque quemcumque quocumque quicumque quorumcumque quibuscumque quoscumque quibuscumque
                                               quaecumque cuiuscumque cuicumque quamcumque quacumque quaecumque quarumcumque quibuscumque quascumque quibuscumque
                                               quodcumque cuiuscumque cuicumque quodcumque quocumque quaecumque quorumcumque quibuscumque quaecumque quibuscumque }
    end
  end

  context "with uterque" do
    it "builds all forms" do
      args = [{type: :pronoun, inflection_class: :uterque}]
      form_builder_strings(args).should == %w{ uterque utriusque utrique utrumque utroque utrique utrorumque utrisque utrosque utrisque
                                               utraque utriusque utrique utramque utraque utraeque utrarumque utrisque utrasque utrisque
                                               utrumque utriusque utrique utrumque utroque utraque utrorumque utrisque utraque utrisque }
    end
  end

  context "with is" do
    it "builds all forms" do
      pending
      args = [{type: :pronoun, inflection_class: :is}]
      form_builder_strings(args).should == %w{}
    end

    it "builds only correct forms" do
      opts = { stem: "E", ending: "o"}
      args = [{type: :pronoun, inflection_class: :is, options: opts}]
      form_builder_strings(args).should include("eo")
    end

    context "with alternate forms" do
      def strings_of(stem, ending)
        opts = { stem: stem, ending: ending, validate: true }
        args = [{type: :pronoun, inflection_class: :is, options: opts}]
        form_builder_strings(args)
      end

      it "works with is, iis and eis" do
        strings_of("i", "s") .should == %w{ is }  * 7 # nom m as well!
        strings_of("i", "is").should == %w{ iis } * 6
        strings_of("e", "is").should == %w{ eis } * 6
      end
    end
  end

  context "with idem" do
    it "builds all forms" do
      pending
      args = [{type: :pronoun, inflection_class: :isdem}]
      form_builder_strings(args).should == %{}
    end

    context "with alternating forms" do
      def strings_of(stem, ending)
        opts = { stem: stem, ending: ending, particle: "dem", validate: true }
        args = [{type: :pronoun, inflection_class: :idem, options: opts}]
        form_builder_strings(args)
      end

      it "builds only correct forms of is" do
        strings_of("i", "s").should == %w{ isdem } * 6
      end

      it "builds only correct forms of eis" do
        strings_of("e", "is").should == %w{ eisdem } * 6
      end

      it "builds only correct forms of iis" do
        strings_of("i", "is").should == %w{ iisdem } * 6
      end
    end
  end
end
