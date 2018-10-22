require "yaml"
require "mysql2"

class TestData
  def initialize(mysql_client)
    @mysql_client = mysql_client
  end

  def values
    records = @mysql_client.query("SELECT * FROM test_data", as: :array).to_a
    records.map { |e| e[1] }
  end
end

class SMA
  def self.calculate(testdata, n)
    0.upto(testdata.size - 1 - n).map do |i|
      testdata[i, n].sum / n
    end
  end

  def initialize(mysql_client)
    @mysql_client = mysql_client
  end

  def import(sma_values)
    values_sql = sma_values.map { |v| "(#{v})" }.join(",")
    @mysql_client.query("INSERT INTO smas (`value`) VALUES #{values_sql}")
  end
end

db_config = YAML.load_file("database.yml")
mysql_client = Mysql2::Client.new(db_config)

values = TestData.new(mysql_client).values

sma_values = SMA.calculate(values, 25)
SMA.new(mysql_client).import(sma_values)
