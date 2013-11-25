module LLT
  class Form
    class Adverb < Adjective
      # TODO 27.09.13 00:20 by LFDM
      # Might need a simpler initialize routine than direct inheritance
      # A simple adverb like semper is bloated with instance variables.

      def stem
        @string
      end
    end
  end
end
