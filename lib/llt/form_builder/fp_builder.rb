module LLT
  class FpBuilder < DeclinableBuilder
    builds_like_an :adjective
    builds_with :tempus, :modus, :genus, :extension

    validate :extension

    has_modus  t.participium
    has_genus  t.activum
    has_tempus t.futurum
    has_extension "ur"
  end
end
