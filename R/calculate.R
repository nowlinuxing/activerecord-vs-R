library(yaml)
library(RMySQL)

dbConfig <- yaml.load_file("database.yml")
conn <- do.call(dbConnect, c(dbDriver("MySQL"), dbConfig))

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
