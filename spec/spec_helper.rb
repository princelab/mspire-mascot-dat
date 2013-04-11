require 'rspec'

require 'fileutils'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
#Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

SPEC_DIR = File.dirname(__FILE__)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.formatter = :documentation
end

TESTFILES = SPEC_DIR + "/testfiles"

# creates a tmpdir, passes it into the block as a full path, then destroys at
# close of block.  Returns whatever was returned by the block.
def spec_tmpdir(&block)
  dir = File.expand_path(SPEC_DIR + "/tmp")
  FileUtils.rm_rf( dir )
  FileUtils.mkdir( dir )
  reply = block.call(dir)
  FileUtils.rm_rf( dir )
  reply
end
