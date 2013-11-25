module LLT
  class FormBuilder
    class StemHashParser

      include Helpers::Normalizer

      def initialize(stem_hashes)
        @stem_hashes = stem_hashes.map { |h| normalize_args(h) }
        @result = []
      end

      def parse
        @stem_hashes.each do |hash|
          @hash = hash
          @opts = hash[:options]

          m = "#{type}_changes"
          if respond_to?(m)
            send(m)
          else
            add_unchanged
          end
        end

        @result
      end


####### Praesens Changes #######

      def praesens_changes
        verbal_changes do |ext, m, tmp|
          parse_verb(:extension, ext)
          parse_verb(:mood, m)

          default_verbal_types(m, ext, tmp)
        end
      end

####### Perfectum Changes #######

      def perfectum_changes
        verbal_changes do |ext, m, tmp|
          parse_verb(:mood, m)
          parse_verb(:extension, ext)

          default_verbal_types(m, ext, tmp)
        end
      end


####### PPP Changes #######

      def ppp_changes
        verbal_changes do |ext, m, tmp|
          parse_verb(:extension, ext)
          parse_verb(:mood, m)
          parse_verb(:tempus, tmp)

          add_with_new_type(*verb_defaults) unless m || ext || tmp
        end
      end

####### Adjective Changes #######

      def adjective_changes
        add_unchanged
        unless irregular_adverb_building? || invalid_options?
          stem = comparativus? ? adapted_stem : @hash[:stem]
          add(@hash.merge(stem: stem, type: :adverb)) unless irregular_adverb_building?
        end
      end

      def adapted_stem
        @hash[:stem].sub(/ior$/, "ius")
      end

      def irregular_adverb_building?
        @hash[:irregular_adverb]
      end

      def comparativus?
        @hash[:comparatio] == :comparativus
      end

      def invalid_options?
        if @opts
          @opts[:sexus] || @opts[:numerus] || @opts[:casus]
        end
      end


######### Pronoun Changes #########

      def pronoun_changes
        if kind_of_quisque && @opts[:ending] == "is"
          # whether quisque or quisque_s arrive - always return both
          base_infl = inflection_class.to_s.match(/([a-z]+)_?/)[1]
          types = [base_infl, base_infl + "_s"].map(&:to_sym)
          add_with_new_inflection_class(*types)
        else
          add_unchanged
        end
      end

      def kind_of_quisque
         /quisque/ =~ inflection_class
      end


####### General Helper #######

      def type
        @hash[:type]
      end

      def inflection_class
        @hash[:inflection_class]
      end

      def add_with_new_type(*types)
        types.each do |type|
          @result << @hash.merge(type: type)
        end
      end

      def add_with_new_inflection_class(*infl_classes)
        infl_classes.each do |infl_cl|
          @result << @hash.merge(inflection_class: infl_cl)
        end
      end

      def add(hash)
        @result << hash
      end

      def add_unchanged
        @result << @hash
      end


####### Verb Helpers #######

      def verbal_changes
        if @opts
          yield(*attributes)
        else
          add_with_new_type(*verb_defaults)
        end
      end

      def attributes
        %i{ extension modus tempus }.map { |attr| @opts[attr] }
      end


      def verb_defaults
        send("#{type}_defaults")
      end

      def irregular_verb?
        @hash[:inflection_class].kind_of?(Symbol) # all irregulars are given as symbol, regulars come as Fixnum
      end

      IRE_DEFAULTS   = %i{ irregular_praesens irregular_praesens_infinitivum irregular_ppa irregular_gerund irregular_gerundive }
      FERRE_DEFAULTS = %i{ irregular_praesens irregular_praesens_infinitivum ppa gerund gerundive }
      OTHER_DEFAULTS = %i{ irregular_praesens irregular_praesens_infinitivum }
      REG_DEFAULTS   = %i{ praesens praesens_infinitivum ppa gerund gerundive }
      def praesens_defaults
        if irregular_verb?
          case @hash[:inflection_class]
          when :ire   then IRE_DEFAULTS
          when :ferre then FERRE_DEFAULTS
          else OTHER_DEFAULTS
          end
        else
          REG_DEFAULTS
        end
      end

      PERF_DEFAULTS = %i{ perfectum perfectum_infinitivum }
      def perfectum_defaults
        PERF_DEFAULTS
      end

      PPP_DEFAULTS = %i{ ppp fp supinum }
      def ppp_defaults
        PPP_DEFAULTS
      end

      def default_verbal_types(m, ext, tmp)
        unless m || ext
          if tmp || @opts[:finite]
            add_with_new_type(verb_defaults.first) # praesens or perfectum
          else
            add_with_new_type(*verb_defaults)
          end
        end
      end

      def parse_verb(category, var)
        return unless var
        add_with_new_type(*send("#{category}_mapping", var))
      end

      def extension_mapping(ext)
        case ext
        when "nd"    then [:gerund, :gerundive]
        when /^nt?$/ then :ppa
        when "ur"    then :fp
        else orig_type
        end
      end

      def mood_mapping(mood)
        case type
        when :praesens
          case mood
          when mood_term(:participle) then :ppa
          when mood_term(:infinitive) then :praesens_infinitivum
          when mood_term(:gerund)     then :gerund
          when mood_term(:gerundive)  then :gerundive
          else orig_type
          end
        when :perfectum
          case mood
          when mood_term(:infinitive) then :perfectum_infinitivum
          else type
          end
        when :ppp
          case mood
          when mood_term(:participle) then [:ppp, :fp]
          when mood_term(:supinum)    then :supinum
          else type
          end
        end
      end

      def mood_term(val)
        t.value_term_for(:modus, val)
      end

      def tempus_mapping(tmp)
        # more to come, especially for praesens stem probably (ppa? gerundive?)
        case type
        when :ppp
          case tmp
          when t.fut then :fp
          when t.pf  then :ppp
          end
        end
      end

      def orig_type
        if irregular_verb?
          verb_defaults.find { |default| default.match(/#{type}$/) }
        else
          type
        end
      end
    end
  end
end
