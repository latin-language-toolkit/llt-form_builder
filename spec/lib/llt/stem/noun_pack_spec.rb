require 'spec_helper'

describe LLT::Stem::NounPack do
  let(:noun_pack) do
    args = { nom: 'homo', stem: 'homin', inflection_class: 3, sexus: :m, lemma_key: 111 }
    LLT::StemBuilder.build(:noun, args, 'test')
  end

  describe "#lemma" do
    it "obtains its lemma from its nominative" do
      noun_pack.lemma.should == 'homo'
    end
  end

  describe "#lemma_with_key" do
    it "is a combination of the lemma and its lemma_key" do
      noun_pack.lemma_with_key.should == 'homo#111'
    end
  end
end
