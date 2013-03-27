require 'ostruct'
require 'delegate'
require 'cgi'

module Mspire
  module Mascot
    class Dat
      class Query < Hash

        def initialize(io=nil)
          from_string(io) if io
        end

        # returns self
        def from_string(io)
          while line = io.gets
            break if line[0,2] == '--'
            line.chomp!
            (key, val) = line.split('=')
            val = 
              case key
              when 'title'
                CGI.unescape(val)
              when 'charge'
                val.to_i
              end
            self[key.to_sym] = val
          end
          self
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

