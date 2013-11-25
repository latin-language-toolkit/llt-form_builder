require 'spec_helper'

describe LLT::Stem::AdjectivePack do
  let(:ap) { LLT::Stem::AdjectivePack }

  describe "#lemma" do
    it "returns the nominative value of the positive stem" do
      args = { nom: "altus", stem: "alt", inflectable_class: 1, number_of_endings: 3 }
      adj = ap.new(:adjective, args, "")
      adj.lemma.should == 'altus'
    end
  end

  describe "#initialize" do
    context "returns extended stems by default, i.e. three stems: positivus, comparativus, superlativus" do
      context "with regulars" do
        it "builds ior and issimus" do
          # adverb might need to follow - or they take a different path with three stems as well.
          args = { nom: "altus", stem: "alt", inflectable_class: 1, number_of_endings: 3 }

          stems = ap.new(:adjective, args, "").stems
          stems.map(&:stem).should == %w{ alt altior altissim }
        end

        it "builds ior and limus" do
          args = { nom: "facilis", stem: "facil", inflectable_class: 3, number_of_endings: 2 }

          stems = ap.new(:adjective, args, "").stems
          stems.map(&:stem).should == %w{ facil facilior facillim }
        end

        it "builds ior and rimus" do
          args = { nom: "asper", stem: "asper", inflectable_class: 3, number_of_endings: 1 }

          stems = ap.new(:adjective, args, "").stems
          stems.map(&:stem).should == %w{ asper asperior asperrim }
        end

        it "builds ior and rimus (with the e catch as in pulcher)" do
          args = { nom: "pulcher", stem: "pulchr", inflectable_class: 1, number_of_endings: 3 }

          stems = ap.new(:adjective, args, "").stems
          # pulchrior or pulcherior?
          stems.map(&:stem).should == %w{ pulchr pulchrior pulcherrim }
        end
      end

      it "a comparative stem must not contain the nom info from the positivus stem" do
        args = { nom: "altus", stem: "alt", inflectable_class: 1, number_of_endings: 3 }

        stems = ap.new(:adjective, args, "").stems
        pos  = stems.find { |stem| stem.comparatio == :positivus }
        comp = stems.find { |stem| stem.comparatio == :comparativus }
        sup  = stems.find { |stem| stem.comparatio == :superlativus }

        pos .to_hash[:nom].should be_true
        comp.to_hash[:nom].should be_false
        sup .to_hash[:nom].should be_false
      end
    end
  end

  describe "#check_irregularities" do
    it "sets an irregular adverb flag if needed" do
      args = { nom: "bonus", stem: "bon", inflectable_class: 1, number_of_endings: 3 }
      x = ap.new(:adjective, {}, "", false)
      x.send(:check_irregularities, args)
      args[:irregular_adverb].should be_true
    end

    it "builds a distinct adverb stem" do
      args = { nom: "bonus", stem: "bon", inflectable_class: 1, number_of_endings: 3 }
      x = ap.new(:adjective, {}, "", false)
      x.should receive(:add)
      x.send(:check_irregularities, args)
    end
  end
end
