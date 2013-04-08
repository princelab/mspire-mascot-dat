require 'spec_helper'

require 'mspire/mascot/dat/query'

describe 'creating a query object' do

  before(:all) do
    # this is hacked up to be much smaller, so don't look for consistency
    # between the data and the spectrum
    data = <<END
title=1%2e2746%2e2746%2e2
index=1
charge=2-
mass_min=305.484440
mass_max=1998.945430
int_min=1.5
int_max=747
num_vals=3
num_used1=-1
Ions1=371.460240:10.3,486.498990:15.7,538.381160:24.9
--gc0p4Jq0M2Yt08jU534c0p
Content-Type: application/x-Mascot; name="query2"
END
    @io = StringIO.new(data)
  end

  specify 'Query.from_io(io) returns a query object with appropriate casts' do
    query = Mspire::Mascot::Dat::Query.from_io(@io)
    query.title.should == '1.2746.2746.2'
    query.charge.should == -2
  end
end

