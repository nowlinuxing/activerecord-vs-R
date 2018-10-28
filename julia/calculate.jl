using Statistics
using MySQL
using DataFrames

function sma(values::Array, n::Int)
  smas = zeros(size(values, 1) - n + 1)

  for i in n:size(values, 1)
    smas[i - n + 1] = mean(values[i - n + 1:i])
  end

  smas
end

function insert(conn::MySQL.Connection, values::Array)
  values_sql =
    join(
      map(values) do value
        "(NULL, $(value))"
      end,
      ","
    )
  MySQL.execute!(conn, "INSERT INTO `smas` (`id`, `value`) VALUES $(values_sql)")
end

db_host, db_user, db_pass, db_name = ARGS
conn = MySQL.connect(db_host, db_user, db_pass, db = db_name)

data = MySQL.query(conn, "SELECT * FROM test_data") |> DataFrame
smas = sma(data[:value], 25)
insert(conn, smas)

MySQL.disconnect(conn)

