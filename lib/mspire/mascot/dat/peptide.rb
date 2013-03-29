
module Mspire
  module Mascot
    class Dat
      # mr = relative molecular mass; data contains keys of relative
      Peptide = Struct.new(:missed_cleavages, :mr, :delta, :num_ions_matched, :seq, :peaks_from_ions_1, :var_mods_string, :ions_score, :ion_series_found, :peaks_from_ions_2, :peaks_from_ions_3, :query_num, :peptide_num, :proteins, :data) do
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
          (core, prots) = value.split(';', 2)
          pephit = self.new(*core.split(','), qnum, pnum)
          pephit.cast!
          pephit
        end

        # returns the query num and peptide num and info_tag and string.  nil if they don't exist.
        def self.dissect_line(line)
          if md=/q(\d+)_p_?(\d+)(\w*)=(.*)/.match(line)
            [md[1].to_i, md[2].to_i, md[3], md[4]]
          end
        end

        def cast!
          self.each_pair do |k,v|
            if cast=CAST[k]
              apply = cast.is_a?(Symbol) ? cast.to_proc : cast
              self[k] = apply[v] if apply
            end
          end
        end

        def self.each_peptide(io, &block)
          block or return enum_for(__method__, io)
          before = io.pos
          peptide = nil
          while reply=dissect_line(io.readline("\n"))
            p reply
            (qnum, pnum, info_tag, value) = reply
            if info_tag == ''
              block.call(peptide) if peptide # yield the previous peptide
              peptide = self.from_value_string(value, qnum, pnum)
            else
              # implement reading in future
            end
            before = io.pos
          end
          # yield that last peptide
          block.call(peptide) if peptide
        end
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

