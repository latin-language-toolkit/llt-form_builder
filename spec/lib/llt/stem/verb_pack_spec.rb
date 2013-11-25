require 'spec_helper'

describe LLT::Stem::VerbPack do
  let(:vp)   { LLT::Stem::VerbPack }
  let(:args) do
    {
      pr: "ama", pf: "amav", ppp: "amat",
      inflection_class: 1,
      dir_objs: "4 aci", indir_objs: "3" # fantasy values of course
    }
  end

  # In case you wonder, the empty string in vp.new indicates
  # a source where the stem info came from, e.g. the Prometheus db.

  describe "#initialize" do
    it "returns three stems when initialized with a prometheus styled hash by default" do
      stem_pack = vp.new(:verb, args, "")
      stem_pack.stems.should have(3).items
      stem_pack.stems.map(&:type).should == %i{ praesens perfectum ppp }
      stem_pack.stems.map(&:stem).should == %w{ ama amav amat }
    end

    it "returns without missing stems, i.e. when a key/value pair is missing from the init args" do
      defective_args = args.reject { |k, _| k == :pf }
      stem_pack = vp.new(:verb, defective_args, "")
      stem_pack.stems.map(&:type).should == %i{ praesens ppp }
    end

    it "an irregular stem can be initialized with an empty string or any other value" do
      irregular_args = args.merge(pr: "")
      stem_pack = vp.new(:verb, irregular_args, "")
      stem_pack.stems.map(&:type).should == %i{ praesens perfectum ppp }
    end

    describe "parses and converts valencies" do
      it "makes them accessible as direct_objects and indirect_objects" do
        stem_pack = vp.new(:verb, args, "")

        stem_pack.direct_objects.should == [4, :aci]
        stem_pack.indirect_objects.should == [3]
      end

      it "uses a default value when their value is 'not_set'" do
        mod_args = args
        mod_args[:dir_objs] = "not_set"
        mod_args[:indir_objs] = "not_set"

        stem_pack = vp.new(:verb, mod_args, "")

        stem_pack.direct_objects.should == [4, :aci, :infinitive]
        stem_pack.indirect_objects.should == [3]
      end
    end
  end
end
