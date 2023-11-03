cashFlow <- read.csv("/Users/anshumandash/Documents/Anshuman files/College work/Fina research/cash_flow_ferc1.csv")
str(cashFlow)
head(cashFlow)

## install.packages("DBI")
## install.packages("RSQLite")
library(RSQLite)
library(dplyr)
library(DBI)
library(tidyverse)

# connect to the sqlite file
sqlite    <- dbDriver("SQLite")
mainPudl <- dbConnect(sqlite,"/Users/anshumandash/Documents/Anshuman files/College work/Fina research/Renewable-Energy-Financing/pudl-v2022.11.30/pudl_data/sqlite/pudl.sqlite")

dbListTables(mainPudl)

## getting an individual table from the list of tables
boiler_fuel <- tbl(mainPudl, "boiler_fuel_eia923")
str(boiler_fuel)
boiler_fuel_df <- collect(boiler_fuel)

list <- dbListTables(mainPudl)
list
grep("860", list)
list[grepl("860", list)]

boiler_generator_assn_eia860 <- tbl(mainPudl, "boiler_generator_assn_eia860")
boiler_generator_assn_eia860_df <- collect(boiler_generator_assn_eia860)

generators_eia860 <- tbl(mainPudl, "generators_eia860")
generators_eia860_df <- collect(generators_eia860)

plants_eia860 <- tbl(mainPudl, "plants_eia860")
plants_eia860_df <- collect(plants_eia860)

utilities_eia860 <- tbl(mainPudl, "utilities_eia860")
utilities_eia860_df <- collect(utilities_eia860)

boiler_generator_assn_eia860 <- tbl(mainPudl, "boiler_generator_assn_eia860")
boiler_generator_assn_eia860_df <- collect(boiler_generator_assn_eia860)

remove(boiler_fuel)

## wide_data <- spread(long_data, key = Month, value = Sales)
newCashFlow <- spread(cashFlow, key = amount_type, value = c(amount, balance, row_type_xbrl))

## install.packages("reshape2")
library(reshape2)
newCashFlow

## Best working wide form so far : 35k observations
newCashFlow <- dcast(
  cashFlow,
  report_year + utility_id_ferc1 + utility_id_ferc1_label + balance + row_type_xbrl ~ amount_type,
  value.var = "amount",
  fun.aggregate = function(x) x[!is.na(x)][1]
)





