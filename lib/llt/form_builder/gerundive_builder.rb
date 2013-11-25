module LLT
  class GerundiveBuilder < DeclinableBuilder
    builds_like_an :adjective
    builds_with :modus, :extension, :prefix

    has_extension "nd"
    has_modus t.gerundivum

    look_up :thematic

    validate :extension

    # Allows archaic forms like audiundi
    def validation_rule(args, validator)
      if args[:inflection_class] == 4 && validator == :thematic
        if args[validator] == "e" && @options[validator] =~ /^[eu]$/
          keep_given_value(args, validator, :archaic)
        end
      else
        super
      end
    end
  end
end
