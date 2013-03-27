require 'spec_helper'

require 'mspire/mascot/dat'

describe 'reading a dat file' do
  before(:all) do
    @file = TESTFILES + '/F004129.dat'
  end

  it 'knows all the sections, with queries grouped' do
    Mspire::Mascot::Dat.open(@file) do |dat|
      dat.each_peptide do |peptide|
      end
    end

  end

  it 'can retrieve each peptide' do
    start = [ [1,1,'VMLSDADPSLEQYYVNVR'], 
      [2,1,'MDSSSGSQGNGSFMDQNSLGILNMDNLK'],
      [2,2,'STGAESSEEXLREAYIMASVEHVNLLK'],
      [2,3,'LSSPPSTSHTYEGKLLTKPTHTNTDLR'],
      [2,4,'MDSSSGSQGNGSFMDQNSLGILNMDNLK']]

    last = [2,10,'NGSSVAGTSVLSPSIPLTLVVLPALMIAQK']

    Mspire::Mascot::Dat.open(@file) do |dat|
      last_pep = nil
      dat.each_peptide do |peptide|
        last_pep = peptide
        (qnum, pnum, aa) = start.shift
        if qnum
          peptide.query_num.should == qnum
          peptide.peptide_num.should == pnum
          peptide.seq.should == aa
        end
      end
      (qnum, pnum, aa) = last
      peptide = last_pep
      peptide.query_num.should == qnum
      peptide.peptide_num.should == pnum
      peptide.seq.should == aa

      # this proves that each_peptide can also return an enumerator if asked
      cnts = dat.each_peptide.with_index.map do |peptide,i|
        peptide.should(be_a(Mspire::Mascot::Dat::Peptide)) && i
      end
      cnts.should == (0..10).to_a

    end
  end

end
