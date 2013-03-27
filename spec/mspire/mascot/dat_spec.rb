require 'spec_helper'

require 'mspire/mascot/dat'

describe 'dat file can be open for reading with block' do
  let(:file) { TESTFILES + '/F004129.dat' }

  specify '#open(file)' do
    Mspire::Mascot::Dat.open(file) do |dat|
      dat.should be_a(Mspire::Mascot::Dat)
    end
  end
end

describe 'reading a dat file' do
  before(:each) do
    @file = TESTFILES + '/F004129.dat'
    @io = File.open(@file)
    @dat = Mspire::Mascot::Dat.new(@io)
  end

  after(:each) do
    @io.close
  end

  it 'knows all the sections, with queries grouped' do
    @dat.sections.should == [:parameters, :masses, :unimod, :enzyme, :header, :summary, :decoy_summary, :peptides, :decoy_peptides, :proteins, :index, :queries]
  end

  it 'can retrieve queries at random' do
    @dat.query(1).title.should == '1.2746.2746.2'
    @dat.query(2).title.should == '1.2745.2745.4'
  end

  it 'can retrieve every peptide' do
    start = [ [1,1,'VMLSDADPSLEQYYVNVR'], 
      [2,1,'MDSSSGSQGNGSFMDQNSLGILNMDNLK'],
      [2,2,'STGAESSEEXLREAYIMASVEHVNLLK'],
      [2,3,'LSSPPSTSHTYEGKLLTKPTHTNTDLR'],
      [2,4,'MDSSSGSQGNGSFMDQNSLGILNMDNLK']]

    last = [2,10,'NGSSVAGTSVLSPSIPLTLVVLPALMIAQK']

    last_pep = nil
    @dat.each_peptide do |peptide|
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
    cnts = @dat.each_peptide.with_index.map do |peptide,i|
      peptide.should(be_a(Mspire::Mascot::Dat::Peptide)) && i
    end
    cnts.should == (0..10).to_a
  end

  it 'can retrieve decoy peptides' do
    ions_score_target = @dat.each_peptide(true, 1).map do |peptide|
      peptide.should(be_a(Mspire::Mascot::Dat::Peptide))
      peptide.peptide_num.should == 1
      peptide.ions_score
    end
    ions_score_target.should == [0.22, 4.11] 

    ions_score_decoy = @dat.each_peptide(false, 1).map do |peptide|
      peptide.should(be_a(Mspire::Mascot::Dat::Peptide))
      peptide.peptide_num.should == 1
      peptide.ions_score
    end
    ions_score_decoy.should == [3.52, 4.58]
  end

  it 'can retrieve just the n peptides' do
    n = 1
    cnt = 0
    @dat.each_peptide(true, n) do |peptide|
      cnt += 1
      peptide.should(be_a(Mspire::Mascot::Dat::Peptide))
      peptide.query_num.should == cnt
      peptide.peptide_num.should == 1
    end
  end

end
