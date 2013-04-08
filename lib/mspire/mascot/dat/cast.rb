
module Mspire
  module Mascot
    class Dat
      module Cast
        TO_INT_ARRAY = ->(val) { val.split(',').map(&:to_i) }
        FROM_CHARGE_STRING = ->(st) { (st[-1] << st[0...-1]).to_i }
        CGI_UNESCAPE = ->(st) { CGI.unescape(st) }
        FLOAT_PAIRS = ->(st) { st.split(',').map {|pair_s| pair_s.split(':').map(&:to_f) } }
      end

      module Castable
        # expects a hash with the parameter and the way to cast it as a symbol
        # (e.g., :to_f or a lambda).  If no hash given, will attempt to
        # retrieve a class constant 'CAST' which defines the casts.
        def cast!(cast_hash=nil)
          hash = cast_hash || self.class.const_get('CAST')
          self.each_pair do |k,v|
            if cast=hash[k]
              apply = cast.is_a?(Symbol) ? cast.to_proc : cast
              self[k] = apply[v] if apply
            end
          end
          self
        end
      end
    end
  end
end


