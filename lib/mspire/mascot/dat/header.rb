require 'mspire/mascot/dat/section/key_val'
require 'mspire/mascot/dat/cast'

module Mspire
  module Mascot
    class Dat
      # The parameters is a hash with some casting (see CAST) and is
      # accessible with upper case String keys.
      class Header < Hash
        include Section::KeyVal
        include Castable

        CAST = {
          sequences: :to_i,
          sequences_after_tax: :to_i,
          residues: :to_i,
          distribution: Cast::TO_INT_ARRAY,
          distribution_decoy: Cast::TO_INT_ARRAY,
          queries: :to_i,
          max_hits: :to_i,
        }

      end
    end
  end
end
