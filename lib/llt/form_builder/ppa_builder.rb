module LLT
  class PpaBuilder < DeclinableBuilder
    builds_like_an :adjective
    builds_with :modus, :tempus, :extension, :genus

    has_extension "nt"
    has_modus  t.participium
    has_tempus t.praesens
    has_genus  t.activum

    look_up :thematic
    validate :extension

    def corrections(args)
      if args[:ending] == "s"
        args[:extension] = args[:extension].chop
      end
    end
  end
end
