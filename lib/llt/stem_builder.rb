require 'llt/stem'
require 'llt/helpers/constantize'

module LLT
  class StemBuilder
    extend Helpers::Constantize

    def self.build(type, args, source)
      type = parse_type_and_extend_args(type, args)
      pre = complex_stems.include?(type) ? type : ""
      cl  = constant_by_type(:pack, prefix: pre, namespace: LLT::Stem)
      cl.new(type, args, source)
    end

    private

    def self.complex_stems
      %i{ noun adjective verb }
    end

    def self.parse_type_and_extend_args(type, args)
      if type == :persona || type == :place
        add_to_args(type, args)
        :noun
      else
        type
      end
    end

    def self.add_to_args(type, args)
      args[type] = true
    end

    def self.pack_factory(args)
      build(:verb, args, 'llt')
    end

    # TODO 02.10.13 16:07 by LFDM
    # Fill in the string values of the various stems

    # edo deliberately left out atm...
    IRREGULAR_STEMS = {
      esse:  pack_factory(pr: "e/s/es/er", pf: "fu",              inflection_class: :esse),
      posse: pack_factory(pr: "pos/pot",   pf: "potu",            inflection_class: :posse),
      ferre: pack_factory(pr: "fer",       pf: "tul", ppp: "lat", inflection_class: :ferre),
      fieri: pack_factory(pr: "fi",                               inflection_class: :fieri),
      ire:   pack_factory(pr: "",          pf: "",    ppp: "",    inflection_class: :ire),
      velle: pack_factory(pr: "",          pf: "volu",            inflection_class: :velle),
      nolle: pack_factory(pr: "",          pf: "nolu",            inflection_class: :nolle),
      malle: pack_factory(pr: "",          pf: "malu",            inflection_class: :malle),
    }
  end
end
