library(tidyverse)
library(tidycensus)
library(sf)

# 2020 Decennial variables (PL 94-171)
race_vars_2020 <- c(
  hispanic = "P2_002N",
  white    = "P2_005N",
  black    = "P2_006N",
  asian    = "P2_008N"
)

# 2010 Decennial variables (SF1)
race_vars_2010 <- c(
  hispanic = "P004003",
  white    = "P005003",
  black    = "P005004",
  asian    = "P005006"
)

# 2000 Decennial variables (SF1)
race_vars_2000 <- c(
  hispanic = "P004002",
  white    = "P004005",
  black    = "P004006",
  asian    = "P004008"
)

# Download 2020 state data with geometries
us_2020 <- get_decennial(
  geography = "state",
  variables = race_vars_2020,
  summary_var = "P2_001N",
  year = 2020,
  geometry = TRUE
) |> 
  mutate(year = 2020)

# Download 2010 state data
us_2010 <- get_decennial(
  geography = "state",
  variables = race_vars_2010,
  summary_var = "P005001",
  year = 2010
) |> 
  mutate(year = 2010)

# Download 2000 state data
us_2000 <- get_decennial(
  geography = "state",
  variables = race_vars_2000,
  summary_var = "P004001",
  year = 2000
) |> 
  mutate(year = 2000)

# Save state geometries for mapping
us_geo <- us_2020 |> 
  filter(variable == "hispanic") |> 
  select(GEOID, NAME)

write_rds(us_geo, "data/us_geo.rds")

# Combine 2000, 2010, and 2020 census data
us_race_all <- bind_rows(
  us_2000,
  us_2010,
  st_drop_geometry(us_2020)
)

write_rds(us_race_all, "data/us_race_2000_2020.rds")
