require 'active_record/fixtures'
class CreateTestData < ActiveRecord::Migration
  def self.up
    #dir = File.join(File.dirname(__FILE__), "../dev_data")
    #Fixtures.create_fixtures(dir, "ipnets")
  end

  def self.down
  end
end
