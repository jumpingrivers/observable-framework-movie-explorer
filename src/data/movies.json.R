library(dplyr)
library(RSQLite)
library(dbplyr)

script_directory = gsub("--file=", "", commandArgs()[4])
db_path = file.path(dirname(script_directory), "movies.db")

conn = dbConnect(RSQLite::SQLite(), db_path)
omdb = tbl(conn, "omdb")
tomatoes = tbl(conn, "tomatoes")


all_movies = inner_join(omdb, tomatoes, by = "ID") %>%
  filter(Reviews >= 10 & !is.na(BoxOffice)) %>%
  select(Title, Runtime, Genre, Released, Director, Oscars,
    Rating = Rating.y, Meter, Reviews, BoxOffice, Cast) %>%
  mutate(BoxOffice = BoxOffice / 1e6)

json = all_movies %>%
  collect() %>%
  jsonlite::toJSON()

dbDisconnect(conn)

print(json)
