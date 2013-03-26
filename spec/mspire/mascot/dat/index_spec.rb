require 'spec_helper'

require 'mspire/mascot/dat/index'

describe 'Mspire::Mascot::Dat::Index being initialized from file' do

  let(:file) { TESTFILES + "/F004128.dat" }

  specify '#initialize(filename) creates the index object' do
    Mspire::Mascot::Dat::Index.new(file).should be_a(Mspire::Mascot::Dat::Index)
  end

  describe Mspire::Mascot::Dat::Index do
    subject { Mspire::Mascot::Dat::Index.new(file) }

    it 'can access the header start bytes' do

      {
        :parameters => 4,
        :masses => 78,
        :unimod => 119,
        :enzyme => 484,
        :header => 492,
        :summary => 507,
        :peptides => 820,
        :proteins => 853,
      }.each {|head,val| subject[head].should == val }

    end

    it 'can get the queries' do
      [1,2].zip([858, 871]) do |num, byte|
        subject.query(num).should == byte
      end
    end

    it 'can be accessed with brackets like array or hash' do
      subject[1].should == 858
      subject[:peptides].should == 820
      subject['peptides'].should == 820
    end

  end
end
