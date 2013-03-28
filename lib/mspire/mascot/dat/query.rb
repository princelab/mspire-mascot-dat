require 'ostruct'
require 'delegate'
require 'cgi'

module Mspire
  module Mascot
    class Dat
      class Query < Hash

        CAST = {
          charge: ->(_) { (st[-1] << st[0...-1]).to_i },
          title: ->(_) { CGI.unescape(_) },
          mass_min: :to_f,
          mass_max: :to_f,
          int_min: :to_f,
          int_max: :to_f,
          num_vals: :to_i,
          num_used1: :to_i,
          index: :to_i,
          Ions1: ->(_) { _.split(',').map {|pair_s| pair_s.split(':').map(&:to_f) } },
        }

        # returns self
        def self.from_io(io)
          query = self.new
          while line = io.gets
            break if line[0,2] == '--'
            line.chomp!
            (key, val) = line.split('=')
            query[key.to_sym] = val
          end
          query.each do |k,v|
            if cast=CAST[k]
              apply = cast.is_a?(Symbol) ? cast.to_proc : cast
              query[k] = apply[v] if apply
            end
          end
          query
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

