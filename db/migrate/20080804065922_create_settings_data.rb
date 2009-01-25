require 'active_record/fixtures'

class CreateSettingsData < ActiveRecord::Migration

  def self.up
    dir = File.join(File.dirname(__FILE__), "../dev_data")
    Fixtures.create_fixtures(dir, "settings")
  end

  def self.down
  end

end
