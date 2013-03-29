require 'spec_helper'

require 'mspire/mascot/dat/peptide'

describe 'reading off a Peptide' do

  before(:all) do
    file = TESTFILES + '/F004129.dta'
     HERERER 
    
  end

  it 'works' do
    peptide = Mspire::Mascot::Dat::Peptide.from_io(@io)
    { missed_cleavages: 0, mr: 2978.269196, delta: 1.19584, num_ions_matched: 5, seq: 'MDSSSGSQGNGSFMDQNSLGILNMDNLK', peaks_from_ions_1: 17, var_mods_string: '000000000000001000000000100000', ions_score: 4.11, ion_series_found: '0002000020000000000', peaks_from_ions_2: 0, peaks_from_ions_3: 0, query_num: 2, peptide_num: 1, proteins: nil, data: nil }.each do |k,v|
      peptide.send(k).should == v
    end
  end

end
