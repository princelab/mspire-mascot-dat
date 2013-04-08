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

  it 'can retrieve normal or decoy peptides' do
    ions_score_target = @dat.each_peptide(true, 1).map do |peptide|
      peptide.should(be_a(Mspire::Mascot::Dat::Peptide))
      peptide.peptide_num.should == 1
      peptide.ions_score
    end
    ions_score_target.should == [0.22, 4.11] 

    [:to_a, :reverse].each do |ar_order|
      args = [1, false].send(ar_order)
      ions_score_decoy = @dat.each_peptide(*args).map do |peptide|
        peptide.should(be_a(Mspire::Mascot::Dat::Peptide))
        peptide.peptide_num.should == 1
        peptide.ions_score
      end
      ions_score_decoy.should == [3.52, 4.58]
    end
  end

  it 'can retrieve just the n peptides' do
    n = 1
    cnt = 0
    @dat.each_peptide(n) do |peptide|
      cnt += 1
      peptide.should(be_a(Mspire::Mascot::Dat::Peptide))
      peptide.query_num.should == cnt
      peptide.peptide_num.should == 1
    end
  end

  specify '#section(:peptides) returns an enumerator (or takes a block)' do
    @dat.section(:peptides).should be_an(Enumerator)
    @dat.section(:peptides).map(&:peptide_num).should == [1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @dat.section(:peptides).map(&:query_num).should == [1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]
    @dat.section(:peptides).map(&:ions_score).should == [0.22, 4.11, 2.84, 2.83, 2.65, 2.28, 1.07, 0.99, 0.96, 0.65, 0.63]
    @dat.section(:peptides, true, 1).map(&:peptide_num).should == [1,1]
  end

  specify '#section(:decoy_peptides) returns an enumerator (or takes a block)' do
    @dat.section(:decoy_peptides).should be_an(Enumerator)
    @dat.section(:decoy_peptides).map(&:peptide_num).should == [1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    @dat.section(:decoy_peptides).map(&:query_num).should == [1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]
    @dat.section(:decoy_peptides).map(&:ions_score).should == [3.52, 4.58, 3.46, 3.3, 3.05, 3.05, 2.99, 2.97, 2.97, 2.87, 2.87] 
    @dat.section(:decoy_peptides, 1).map(&:peptide_num).should == [1,1]
  end

  specify "#parameters returns a hash-like object with proper casts" do
    params = @dat.section(:parameters)
    params.should be_a(Mspire::Mascot::Dat::Parameters)
    params['IATOL'].should be_nil
    params.key?('IATOL').should be_true
    params.key?('silliness').should be_false
    params['IT_MODS'].should == 'Oxidation (M)'
    params['TOL'].should == 1.2
    params['CHARGE'].should == 2
  end

  #specify '#section(:queries) returns an enumerator (or takes a block)' do
  #  @dat.section(:queries).should be_an(Enumerator)
  #end

end
