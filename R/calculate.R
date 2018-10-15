library(RMySQL)

conn <- dbConnect(dbDriver("MySQL"), host = "127.0.0.1", dbname = "testdb", user = "user", password = "password")
dat <- dbReadTable(conn, "test_data")
sma <- na.omit(filter(dat$value, rep(1:1, 25)))

valuesSQL <- paste(
  "(NULL, ",
  sma,
  ")",
  sep = "",
  collapse = ","
)
insertSQL <- paste(
  "INSERT INTO `smas` (`id`, `value`) VALUES",
  valuesSQL
)

dbSendQuery(conn, insertSQL)

dbDisconnect(conn)
