require "yaml"
require "active_record"
require "activerecord-import"

class TestData < ActiveRecord::Base
end

class SMA < ActiveRecord::Base
  def self.calculate(test_data, n)
    0.upto(test_data.size - 1 - n).map do |i|
      [test_data[i, n].sum(&:value) / n]
    end
  end
end

db_config = YAML.load_file("database.yml")
ActiveRecord::Base.establish_connection(db_config)

columns = %w(value)
test_data = TestData.all
sma_values = SMA.calculate(test_data, 25).compact
SMA.import(columns, sma_values, validate: false)
