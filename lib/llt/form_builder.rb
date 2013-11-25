require 'set'

require 'llt/helpers'
require 'llt/constants'
require 'llt/core_extensions/array'

require 'llt/form'
require 'llt/form_builder/version'
require 'llt/form_builder/helpers/adjective_like_building'
require 'llt/form_builder/helpers/pronoun_segments'
require 'llt/form_builder/helpers/stem_hash_parser'
require 'llt/form_builder/helpers/verb_segments'

require 'llt/stem'

module LLT
  class FormBuilder

    include Helpers::Constantize
    include Helpers::Initialize
    include Helpers::Metrical
    include Helpers::Normalizer

    extend Helpers::Normalizer
    extend Helpers::Constantize

    class << self
      def build(*stem_hashes)
        stem_hashes = StemHashParser.new(stem_hashes).parse
        stem_hashes.flat_map do |stem|
          builder_kl = constant_by_type(stem[:type], suffix: "builder")
          builder_kl.new(stem).compute
        end.compact # adverb might return nil forms
      end

      # Defines the class to use for obtaining additional build information
      # like thematic vowels or stem extension (e.g. an Imperfectum -ba-).
      # Defaults to VerbSegments, most commonly used.
      #
      # The argument should be a Class name.
      def lookup_class(arg = nil)
        arg ? @lookup_class = arg : @lookup_class ||= VerbSegments
      end

      # Holds a list of attributes, that will be validated.
      def validations
        @validations ||= []
      end

      private

      # Defines the class of the outputted forms. Defaults to the
      # stem type, # e.g. a :noun stem will build Noun objects.
      #
      # Takes a symbol as argument.
      def form_class(arg)
        define_method(:form_class) do
          constant_by_type(arg, namespace: LLT::Form)
        end
      end

      # Defines which information is needed to obtain the proper set of
      # endings for a stem. E.g. a noun uses its inflection_class and sexus.
      def endings_defined_through(*args)
        define_method(:endings_attributes) do
          args.map { |arg| instance_variable_get("@#{arg}") }
        end
      end

      # Defines which endings shall be used, defaults to the stem's type,
      # a noun stem uses noun endings.
      # Used by irregular_ppa stems - they use the regular ppa endings.
      def uses_endings_of(val)
        define_method(:endings_container) { val }
      end

      # Defines additional attributes that shall be passed
      # to the newly built Form object. Cf. #default_args
      def builds_with(*args)
        anonymous = Module.new do
          define_method(:default_args) do
            # [:a, :b] to { a: a, b: b }, where a and b are method calls,
            # evaluated in the instance's scope.
            hsh = Hash[ args.map { |arg| [arg, send(arg)] } ]

            # Mind the empty brackets, super throws an exception
            # inside of define_method otherwise
            super().merge(hsh)
          end
        end

        include anonymous
      end

      # Defines which attributes shall be looked up in the lookup_class.
      # Such values are automatically included in the validation process.
      def look_up(*vars)
        vars.each do |arg|
          anon = Module.new do
            define_method(:extensions_and_other_signs) do |args|
              kl  = self.class.lookup_class
              val = kl.get(arg, args.merge(default_args))
              args[arg] = val unless val.empty?
              super(args)
            end
          end

          include anon
        end

        validate(vars)
      end

      # Defines arguments that need to be validated.
      def validate(*args)
        validations << args
        validations.flatten!
      end

      # Responds to has_*** methods and takes one argument.
      # Defines default values for certain attributes,
      # e.g. a Gerund's stem always has_extension "nd".
      def method_missing(meth, *args, &blk)
        if meth.to_s.match(/^has_(.*)/)
          define_method($1) { args.first }
        else
          super
        end
      end

      # Syntactic sugar to include modules with special behavior.
      def builds_like_an(arg)
        include FormBuilder.const_get("#{arg.capitalize}LikeBuilding")
      end
      alias :builds_like_a :builds_like_an
    end

    files = %w{ declinable noun ppp adjective ethnic
                pronoun personal_pronoun
                verb praesens perfectum ppa fp gerund gerundive supinum
                infinitivum praesens_infinitivum perfectum_infinitivum
                irregular_praesens  irregular_ppa
                irregular_gerundive irregular_gerund
                irregular_praesens_infinitivum
                adverb }
    files.each do |file|
      require "llt/form_builder/#{file}_builder"
    end

    attr_reader :impersonalium

    def initialize(stem)
      extract_normalized_args!(stem)

      # Used to evaluate if metrical endings and extensions shall be used
      evaluate_metrical_presence(@stem) if @stem # pronouns come without their stem

      @options = stem[:options] || {}
      @validate = @options[:validate] if @options
      @lookup_indices = lookup_indices

      # Use only downcased stem string in the following events,
      # only persons and places are allowed to be capitalized.
      downcase_all_stems unless stays_capitalized
    end

    def init_keys
      # normalized values need to be used here!
      # call a normalize method on this array, which needs to be built
      %i{ type stem inflection_class nom deponens sexus impersonalium persona place }
    end

    # The method called by FormBuilder.build to run the building process.
    # Subclasses overwrite this for more complex computations.
    def compute
      regular_forms
    end

    # Computes a one-dimensional array of indices.
    #
    # LLT::Constants::Endings provides endings for all valid
    # Latin forms. Their index defines additional attributes.
    #
    # Contrived Example:
    #   The row %w{ o s t mus tis nt } presents personal endings
    #   for verbs. Index 0 (o) maps to persona: 1, numerus: 1,
    #   index 3 (mus) maps to persona: 1, numerus: 2.
    #
    # All FormBuilder subclasses need to implement #indices, consisting
    # of a hash that reveals the meaning of an index.
    #
    # An implementation for the personal endings presented above would be
    #   { persona: [0, 1, 2], numerus: [0, 3] }
    #
    # This tells us that there are 3 different values for persona - changing
    # on every first, second and third position - and 2 values for numerus -
    # changing on every fourth position in the endings array.
    #
    # Depending on the presence of options in the given stem_hash, only
    # selected indices are returned.
    def lookup_indices
      if ending = @options[:ending]
        indices_by_ending(ending)
      else
        arr = indices.map do |attr, index_values|
          if opt_val = @options[attr]
            index = value_as_index(opt_val)
            [index_values[index - 1]].compact
          else
            index_values.compact
          end
        end

        cross_indices(arr)
      end
    end

    def indices_by_ending(ending)
      endings.select_indices { |x| endings_lookup(ending, x) }
    end

    # Can be overwritten by subclasses if special rules are needed.
    def endings_lookup(ending, x)
      x.to_s == ending
    end

    # LLT::Constants::Terminology provides a numeric representation of
    # every valid value, e.g. tempus: :praesens == tempus: 1
    def value_as_index(val)
      if val.kind_of?(Fixnum)
        val
      else
        t.send(val, :numeric)
      end
    end

    def cross_indices(arr)
      arr.inject(:product).map(&:flatten).map { |a| a.inject(:+) }.sort
    end

    # General purpose method to map indices to attributes using the
    # #indices hash.
    # Several subclasses use an easier algorithm due to computational
    # efficiency.
    def attributes_by_index(index)
      attrs = {}
      indices.to_a.reverse.each do |type, indices|
        indices.reverse.each_with_index do |ind, i|
          if (index - ind) >= 0
            index -= ind
            attrs[type] = reverse_lookup[type][i]
            break
          end
        end
      end
      attrs.values.reverse
    end

    def reverse_lookup
      @rl ||= indices.each_with_object({}) do |(type, values), h|
        h[type] = t.norm_values_for(type).take(values.size).reverse
      end
    end

    def new_form(args)
      args = args.merge(default_args)
      extensions_and_other_signs(args)
      corrections(args)
      form_class.new(args) if valid?(args)
    end

    def corrections(args)
    end

    def extensions_and_other_signs(args)
    end

    def validations
      self.class.validations
    end

    # used by VerbBuilder, PppBuilder (for irregulars)
    # GerundiveBuilder and GerundBuilder
    def prefix
      p = @options[:prefix].to_s
      p unless p.empty?
    end

    def valid?(args)
      if needs_validation?
        validations.all? do |validator|
          validation_rule(args, validator)
        end
      else
        true
      end
    end

    def needs_validation?
      @validate && validations.any?
    end

    def validation_rule(args, validator)
      args[validator].to_s == @options[validator].to_s
    end

    # Used especially with archaic forms, where a special validation rule
    # is present, like audiundi. It enters the FB process with thematic u
    # (archaic) which is looked up as e but passes the validation. Still
    # we want to present the new forms like they were requested, with their
    # archaic appearance.
    # Only call this after you pass validation!
    # @param args [Hash] - arguments used for form building
    # @param validator [Symbol] - key that is used for validation
    # @param classification [Symbol] - adds info why this value should be kept,
    #   e.g. an archaic form
    # @return [true]
    def keep_given_value(args, validator, classification = nil)
      # work in the classification first, as it might be nil
      # and we want the method to return true, as it will get
      # most frequently called at the end of a passing validation!
      args[:classification] = classification
      args[validator] = @options[validator]
    end

    def default_args
      { stem: stem_copy, inflection_class: @inflection_class }
    end

    def stem_copy
      # solely needed for irregular verbs, they might come without
      # a stem value, which will be set in the course of events
      @stem ? @stem.clone : ""
    end

    def form_class
      constant_by_type(namespace: LLT::Form)
    end

    def endings
      endings_path.get(*endings_attributes)
    end

    def endings_attributes
      []
    end

    def endings_container
      @type
    end

    def endings_path
      path = constant_by_type(endings_container, namespace: endings_namespace)
      metrical? ? path::Metrical : path
    end

    def endings_namespace
      LLT::Constants::Endings
    end

    def downcase_all_stems
      @stem.downcase! if @stem
      @options[:stem].downcase! if @options[:stem]
    end

    def stays_capitalized
      false
    end
  end
end
