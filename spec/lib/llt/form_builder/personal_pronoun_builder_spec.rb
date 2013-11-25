require 'spec_helper'

describe LLT::FormBuilder do
  describe ".build" do
    context "with personal pronouns" do
      context "builds all forms" do
        it "of ego" do
          arg = { type: :personal_pronoun, inflection_class: :ego }
          forms = LLT::FormBuilder.build(arg)
          forms.should have(11).items
          forms.map(&:to_s).should =~ %w{ ego mei mihi me me mecum egomet memet mihimet meimet memet}
          forms.map(&:numerus).all? { |n| n == 1}.should be_true
        end

        it "of tu" do
          arg = { type: :personal_pronoun, inflection_class: :tu }
          forms = LLT::FormBuilder.build(arg)
          forms.should have(10).items
          forms.map(&:to_s).should =~ %w{ tu tui tibi te te tecum tute tete tete tibimet }
          forms.map(&:numerus).all? { |n| n == 1}.should be_true
        end

        it "of nos" do
          arg = { type: :personal_pronoun, inflection_class: :nos }
          forms = LLT::FormBuilder.build(arg)
          forms.map(&:to_s).should =~ %w{ nos nostri nostrum nobis nos nobis nobiscum nosmet nosmet nobismet nobismet }
          forms.map(&:numerus).all? { |n| n == 2}.should be_true
        end

        it "of vos" do
          arg = { type: :personal_pronoun, inflection_class: :vos }
          forms = LLT::FormBuilder.build(arg)
          forms.should have(11).items
          forms.map(&:to_s).should =~ %w{ vos vestri vostrum vobis vos vobis vobiscum vosmet vosmet vobismet vobismet }
          forms.map(&:numerus).all? { |n| n == 2}.should be_true
        end

        it "of se - sg. & pl." do
          arg = { type: :personal_pronoun, inflection_class: :se }
          forms = LLT::FormBuilder.build(arg)
          forms.should have(14).items
          forms.map(&:to_s).should =~ %w{ sui sibi se sese se secum sese } * 2
          forms[0..6] .map(&:numerus).all? { |n| n == 1}.should be_true
          forms[7..14].map(&:numerus).all? { |n| n == 2}.should be_true
        end
      end
    end
  end
end
