module LLT
  class Stem
    class VerbPack < Pack
      attr_reader :direct_objects, :indirect_objects

      def initialize(type, args, source, extension = true)
        super
        extract_valencies(args)

      end

      def to_hash(use = nil, options = {})
        if use
          stem = @stems.find { |st| st.type == use }
          stem.to_hash.merge(options: options)
        end
      end

      def extract_valencies(args)
        d = args[:dir_objs]
        i = args[:indir_objs]

        @direct_objects, @indirect_objects = parse_valencies(d, i)
      end

      def parse_valencies(d, i)
        if d.nil? || d == "not_set"
          [[4, :aci, :infinitive], [3]]
        else
          [d, i].map { |val| convert_valencies(val)}
        end
      end

      def convert_valencies(val)
        val.split.map do |val_string|
          meth = (val_string.match(/^\d$/) ? :to_i : :to_sym)
          val_string.send(meth)
        end
      end

      STEMS = %i{ praesens perfectum ppp }
      def extended_stems(args)
        STEMS.map do |type|
          new_type = args[t.send(type, :abbr)]
          next unless new_type
          args[:stem] = new_type
          create_stem(type, args)
        end.compact
      end

    end
  end
end
