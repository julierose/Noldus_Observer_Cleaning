library(tidyr)
library(dplyr)
library(readxl)
library(writexl)
library(stringr)
library(lubridate)


obs_import <- read_excel("FILEPATH", 
                         col_types = c("guess","guess","guess","numeric","guess"
                                       ,"guess","numeric","numeric","numeric",
                                       "text","text","text","text","text",
                                       "text","text","text"))
#I added the coltypes here because for some reason R was reading Modifier_2 as a 
#logical and it should be a text column. Everything else was being guessed
#correctly so I left the dates as "guess" as they then automatically import as
#POSIXct format

str(obs_import) #check to make sure everything imported correctly

