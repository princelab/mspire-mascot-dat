require 'spec_helper'

require 'mspire/mascot/dat/index'

require 'fileutils'

describe 'Mspire::Mascot::Dat::Index being initialized from file' do

  let(:io) { File.open(TESTFILES + "/F004128.dat") }

  specify '#initialize(io) creates the index object' do
    Mspire::Mascot::Dat::Index.new.from_io!(io).should be_a(Mspire::Mascot::Dat::Index)
  end

  describe Mspire::Mascot::Dat::Index do
    subject { Mspire::Mascot::Dat::Index.new.from_io!(io) }

    it 'can access the header start byte nums' do

      {
        :parameters => 196,
        :masses => 1203,
        :unimod => 1873,
        :enzyme => 20540,
        :header => 20661,
        :summary => 21103,
        :peptides => 41624,
        :proteins => 43894,
      }.each {|head,val| subject[head].should == val }

    end

    it 'can get the queries' do
      [1,2].zip([44129, 51186]) do |num, line_num|
        subject.query(num).should == line_num
      end
    end

    it 'can be accessed with brackets like array or hash' do
      subject[1].should == 44129
      subject[:peptides].should == 41624
      subject['peptides'].should == 41624
    end

    # creates then destroys at the end of block
    def tmpdir(name, &block)
    end

    it 'can write the index info and set itself from the file' do
      tmpdir = TESTFILES + "/tmp"
      FileUtils.mkdir( tmpdir )

      bytefile = tmpdir + "/index_bytefile.tmp"
      subject.write( bytefile )

      File.exist?( bytefile ).should be_true
      File.size( bytefile ).should be > 0



      FileUtils.rm_rf( tmpdir )
    end

  end
end
