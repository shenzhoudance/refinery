require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'mocha'
require 'refinery'

class Test::Unit::TestCase
  def setup_default_config
    Refinery::Config.stubs(:default).returns(Refinery::Config.new(
      {
        'aws' => {
          'credentials' => {
            'access_key_id' => 'aki',
            'secret_access_key' => 'sak'
          }
        },
        'processors' => []
      }
    ))
  end
end