
module Mspire
  module Mascot
    class Dat
      module Section
        module KeyVal
          def from_io!(io, as_symbols=true)
            Dat.each_key_val(io) do |key,val| 
              self[ as_symbols ? key.to_sym : key ] = val
            end
            self.send(:cast!) if self.respond_to?(:cast!)
            self
          end
        end
      end
    end
  end
end
