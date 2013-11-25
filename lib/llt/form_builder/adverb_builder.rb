module LLT
  class AdverbBuilder < AdjectiveBuilder
    endings_defined_through :inflection_class, :stem, :comparatio
    validate :ending, :comparison_sign

    def initialize(stem)
      extract_normalized_args!(stem)
      @options = stem[:options] || {}
      @validate = @options.any?
      downcase_all_stems
    end

    def compute
      # endings is not an array in this case, just a plain string
      new_form(ending: endings)
    end

    def comparativus_extraction(stem, args)
      stem.match(/(#{marker(:IUS)})$/)
      new_stem = stem.chomp($1) # do not use chomp! as other forms will get severed
      raise "No comparison sign for comparative present" if new_stem == stem
      [new_stem, $1]
    end
  end
end
