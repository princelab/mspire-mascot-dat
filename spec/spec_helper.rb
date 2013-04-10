require 'rspec'

require 'fileutils'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
#Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.formatter = :documentation
end

TESTFILES = __dir__ + "/testfiles"

# creates a tmpdir, then destroys at close of block
def tmpdir(&block)
  dir = 
  FileUtils.mkdir( )

end
