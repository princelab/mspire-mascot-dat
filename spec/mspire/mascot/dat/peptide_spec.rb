require 'spec_helper'

require 'mspire/mascot/dat/peptide'

describe 'reading off a Peptide' do

  before(:all) do
    info = <<STRING
q2_p1=0,2978.269196,1.195840,5,MDSSSGSQGNGSFMDQNSLGILNMDNLK,17,000000000000001000000000100000,4.11,0002000020000000000,0,0;"Q9VV79":0:1:28:1
q2_p1_terms=-,V
q2_p1_primary_nl=000000000000002000000000200000
q2_p2=1,2979.449478,0.015558,5,STGAESSEEXLREAYIMASVEHVNLLK,45,00000000000000000100000000000,2.84,0000000020000000000,0,0;"Q6SAG3":0:875:901:1 
STRING
    @io = StringIO.new(info)
  end

  it 'works' do
    peptide = Mspire::Mascot::Dat::Peptide.from_io(@io)
    { missed_cleavages: 0, mr: 2978.269196, delta: 1.19584, num_ions_matched: 5, seq: 'MDSSSGSQGNGSFMDQNSLGILNMDNLK', peaks_from_ions_1: 17, var_mods_string: '000000000000001000000000100000', ions_score: 4.11, ion_series_found: '0002000020000000000', peaks_from_ions_2: 0, peaks_from_ions_3: 0, query_num: 2, peptide_num: 1, proteins: nil, data: nil }.each do |k,v|
      peptide.send(k).should == v
    end
  end

end
