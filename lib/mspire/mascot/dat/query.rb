require 'ostruct'
require 'delegate'
require 'cgi'

require 'mspire/mascot/dat/cast'

module Mspire
  module Mascot
    class Dat
      class Query < Hash
        include Castable

        CAST = {
          charge: Cast::FROM_CHARGE_STRING,
          title: Cast::CGI_UNESCAPE,
          mass_min: :to_f,
          mass_max: :to_f,
          int_min: :to_f,
          int_max: :to_f,
          num_vals: :to_i,
          num_used1: :to_i,
          index: :to_i,
          Ions1: Cast::FLOAT_PAIRS,
        }

        # returns self
        def from_io!(io)
          Dat.each_key_val(io) do |key,val|
            self[key.to_sym] = val
          end
          cast!
        end

        def method_missing(*args, &block)
          if args[0].to_s[-1] == '='
            if self.key?(args[0...-1])
              self[ args[0...-1] ] = args[1]
            else
              super(*args, &block)
            end
          else
            if self.key?(args[0])
              self[ args[0] ]
            else
              super(*args, &block)
            end
          end
        end
      end
    end
  end
end

#index=1
#charge=2+
#mass_min=305.484440
#mass_max=1998.945430
#int_min=1.5
#int_max=747
#num_vals=3
#num_used1=-1

