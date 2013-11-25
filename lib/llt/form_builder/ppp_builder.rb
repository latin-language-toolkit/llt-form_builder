module LLT
  class PppBuilder < DeclinableBuilder
    builds_like_an :adjective
    builds_with :modus, :tempus, :genus, :prefix

    has_modus  t.participium
    has_tempus t.perfectum
    has_genus  t.passivum
  end
end
