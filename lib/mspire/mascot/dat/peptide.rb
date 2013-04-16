require 'mspire/mascot/dat/cast'
require 'mspire/mascot/dat/protein_hit_info'

module Mspire
  module Mascot
    class Dat
      # mr = relative molecular mass; data contains keys of relative
      # mr appears to be the uncharged theoretical mass of the peptide
      # delta is probably in mr space, so mr + delta is the experimental
      # measurement of peptide neutral mass.
      Peptide = Struct.new(:missed_cleavages, :mr, :delta, :num_ions_matched, :seq, :peaks_from_ions_1, :var_mods_string, :ions_score, :ion_series_found, :peaks_from_ions_2, :peaks_from_ions_3, :query_num, :peptide_num, :protein_hits_info, :data) do
        include Castable

        # reads the next line.  If it contains valid query information returns
        # an array [query_num, peptide_num, info_tag, value].  If it no valid
        # query information, resets the io position to the beginning of the
        # string and returns nil.
        def self.next_qp_data(io)
          before = io.pos
          line = io.readline("\n")
          if line[0,2] == '--'
            io.pos = before
            nil
          else
            line.chomp!
            (qpstring, value) = line.split('=',2)
            (qns, pns, info_tag) = qpstring.split('_', 3)
            (qnum, pnum) = [qns, pns].map {|ns| ns[1..-1].to_i }
            [qnum, pnum, info_tag, value]
          end
        end

        # given the value part of the initial peptide data (q1_p1=<value>),
        # sets the object's properties. returns the pephit
        def self.from_value_string(value, qnum, pnum)
          (core, prot_s) = value.split(';', 2)
          #"Q5RHP9":0:535:542:1,"Q5RHP9-3":0:338:345:1
          prot_hit_infos = prot_s.split(',').map do |data_s|
            (accession_quoted, *int_strings) = data_s.split(':')
            ProteinHitInfo.new(
              Mspire::Mascot::Dat.strip_quotes(accession_quoted), 
              *int_strings.map(&:to_i)
            )
          end
          pephit = self.new(*core.split(','), qnum, pnum, prot_hit_infos)
          pephit.cast!
          pephit
        end

        # returns the query num and peptide num and info_tag and string.  nil if they don't exist.
        def self.dissect_line(line)
          if md=/q(\d+)_p_?(\d+)(\w*)=(.*)/.match(line)
            [md[1].to_i, md[2].to_i, md[3], md[4]]
          end
        end

   
        # returns each peptide hit.  Some queries will not have *any* hits,
        # and these are *not* yielded.
        def self.each(io, &block)
          return to_enum(__method__, io) unless block
          before = io.pos
          peptide = nil
          while reply=dissect_line(io.readline("\n"))
            (qnum, pnum, info_tag, value) = reply
            if info_tag == ''
              track_pos = io.pos
              block.call(peptide) if peptide # yield the previous peptide
              io.pos = track_pos
              peptide = 
                (value == "-1") ? nil : self.from_value_string(value, qnum, pnum)
            else
              # implement reading in future
            end
            before = io.pos
          end
          # yield that last peptide

          track_pos = io.pos
          block.call(peptide) if peptide
          io.pos = track_pos
        end
      end
      class Peptide
        CAST = {
          missed_cleavages: :to_i, 
          mr: :to_f, 
          delta: :to_f, 
          num_ions_matched: :to_i,
          ions: :string, 
          ions_score: :to_f, 
          peaks_from_ions_2: :to_i,
          peaks_from_ions_3: :to_i,
        }
      end
    end
  end
end

=begin
q1_p1=missed cleavages, (–1 indicates no match)
    peptide Mr,
    delta,
    number of ions matched,
    peptide string,
    peaks used from Ions1,
    variable modifications string,
    ions score,
    ion series found,
    peaks used from Ions2,
    peaks used from Ions3;
    “accession string”: data for first protein
        frame number:
        start:
        end:
        multiplicity,
    “accession string”: data for second protein
        frame number:
        start:
        end:
        multiplicity,
    etc.
q1_p1_et_mods=modification mass,
    neutral loss mass,
    modification description
q1_p1_et_mods_master=neutral loss mass[[,neutral loss mass] ... ]
q1_p1_et_mods_slave=neutral loss mass[[,neutral loss mass] ... ]
q1_p1_primary_nl=neutral loss string
q1_p1_na_diff=original NA sequence,
    modified NA sequence
q1_p1_tag=tagNum:startPos:endPos:seriesID,...
q1_p1_drange=startPos:endPos
q1_p1_terms=residue,residue[[:residue,residue] ... ]
q1_p1_subst=pos1,ambig1,matched1 ... ,posn,ambign,matchedn
q1_p1_comp=quantitation component name
q1_p2=...
=end

