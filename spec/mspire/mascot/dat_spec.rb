require 'spec_helper'

require 'mspire/mascot/dat'

describe 'reading a dat file' do
  before(:all) do
    @file = TESTFILES + '/F004129.dat'
  end

  it 'knows all the sections, with queries grouped' do
    Mspire::Mascot::Dat.open(@file) do |dat|
      dat.each_peptide do |peptide|
        puts "iterativeing over peptide!"
        p peptide
      end
    end

  end

  it 'can retrieve each peptide' do
    Mspire::Mascot::Dat.open(@file) do |dat|
      dat.each_peptide do |peptide|
        p peptide
      end
    end
  end

end
