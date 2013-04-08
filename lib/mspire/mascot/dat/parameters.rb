require 'mspire/mascot/dat/section/key_val'
require 'mspire/mascot/dat/cast'

module Mspire
  module Mascot
    class Dat
      class Parameters < Hash
        include Section::KeyVal
        include Castable

        CAST = {
          'TOL' => :to_f,
          'ITOL' => :to_f,
          'PFA' => :to_i,
          'CHARGE' => Cast::FROM_CHARGE_STRING,
        }

      end
    end
  end
end
