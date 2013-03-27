
module Mspire
  module Mascot
    class Dat
      # mr = relative molecular mass; data contains keys of relative
      Peptide = Struct.new(:missed_cleavages, :mr, :delta, :num_ions_matched, :seq, :peaks_from_ions_1, :var_mods_string, :ions_score, :ion_series_found, :peaks_from_ions_2, :peaks_from_ions_3, :query_num, :peptide_num, :proteins, :data) do
        CAST = [:int, :float, :float, :int, :string, :int, :string, :float, :string, :int, :int]

        # h49_q2 => [49, 2]; q2_p4_primary_nl => [2, 4, 'primary_nl] 
        def self.qnum_pnum(string)
          p string
          (qns, pns, other) = string.split('_', 3)
          [ *[qns, pns].map {|ns| ns[1..-1].to_i }, other ]
        end
        # takes an io object (positioned at the beginning of a peptide hit)
        # and reads off the next peptide hit "q1_p1=0,798.23...". Returns nil
        # if it reaches the end of the section or it is a blank line
        def self.from_io(io, proteins=false, data=false)
          puts "WHERE ARE YOU!"
          p io.pos
          finished = ->(line) { line.size < 2 || line[0,2] == '--' }
          line = io.readline("\n")
          puts "FIRST LINE!!"
          p line
          if finished[line]
            nil
          else
            (qp, core, protein_info) = line.split(/[=;]/)
            (qnum, pnum, _) = qnum_pnum(qp)
            puts "FIRST EXAMINE"
            p qnum
            p pnum
            vals = core.split(',').zip(CAST).map do |val, cast| 
              case cast
              when :int then val.to_i
              when :float then val.to_f
              else 
                val
              end
            end
            pephit = self.new(*vals, qnum, pnum)
            raise NotImplementedError, "not reading proteins or data yet" if proteins || data
            loop do
              before = io.pos
              line = io.readline("\n")
              if finished[line]
                io.pos = before
                break
              end
              (qp, string) = line.split('=')
              (qnum, pnum, other) = qnum_pnum(qp)
              puts "second EXAMINE"
              p qnum
              p pnum
              if pephit.peptide_num != pnum || pephit.query_num != qnum
                io.pos = before
                break
              end
            end
            pephit
          end
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

