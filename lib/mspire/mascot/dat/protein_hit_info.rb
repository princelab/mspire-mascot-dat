
module Mspire
  module Mascot
    class Dat
      # frame_number, start, end and multiplicity are all Integers
      ProteinHitInfo = Struct.new(:accession, :frame_number, :start, :end, :multiplicity) 
    end
  end
end

