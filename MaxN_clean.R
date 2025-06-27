library(dplyr)
library(tidyr)
library(readxl)
library(lubridate)

#I added the coltypes because for some reason R was reading Modifier_2 as a 
#logical and it should be a text column. Everything else was being guessed
#correctly so I left the dates as "guess" as they then automatically import as
#POSIXct format
maxn_import <- read_excel("FILEPATH", col_types = c("guess","guess","guess","numeric","guess"
                                                      ,"guess","numeric","numeric","numeric",
                                                      "text","text","text","text","text",
                                                      "text","text","text"))
View(maxn_import)
str(maxn_import)

#this assumes a standardized filename format which is located in column "Observation"
#It is not unusual for there to be some initial cleaning necessary to get the 
#filenames into the standardized format
maxn <- maxn_import |> 
  separate_wider_delim(cols = Observation, delim = "_", 
                       names = c("Analyst", "Date", "Treatment", "Replicate",
                                 "Camera_Numbers", "Hour")) |> 
  mutate_at(c("Subject", "Behavior", "Modifier_2", "Treatment", "Replicate", 
              "Hour"), as.factor) |> 
  mutate(Date = mdy(Date)) |> 
  filter(Subject == "Subject",
         Behavior %in% c("Black sea bass", "Scup", "Cunner", "Tautog", "Other Fish")) |> 
  rename(MaxN = Modifier_1, Location_on_structure = Modifier_2, Species = Behavior, Seconds = Time_Relative_sf) |>
  select(!c(Date_Time_Absolute_dmy_hmsf, Date_dmy, Time_Absolute_hms, 
            Time_Absolute_f, Time_Relative_hmsf, Time_Relative_hms, 
            Time_Relative_f, Duration_sf, Event_Log, Event_Type, Subject)) |>
  mutate(Hour = parse_date_time(Hour, orders = "%H%p"),
         Hour = hour(Hour),
         Minute = Seconds/60,
         DateTime = as.POSIXct(paste(Date, Hour, Minute), format = "%Y-%m-%d %H %M")) |> 
relocate(Analyst, DateTime, Date, Hour, Minute, Seconds, Treatment, Replicate, Camera_Numbers, Species, MaxN, Location_on_structure, Comment)

View(maxn)
str(maxn)

#For the rarer species, species names are contained in the Comment column
#Other species are observed rarely enough that I just manually replace the species name
#In theory you could code this step but because Comment is free text, misspellings 
#are not unusual and this allows me to QAQC
maxn_other <- maxn |> 
  filter(MaxN > 0 &
         Species == "Other Fish")

View(maxn_other)

#After replacing "Other Fish" with species names, union to original

maxn <- rbind(maxn, maxn_other)

#After replacing "Other Fish" with the rarer species names, can just drop remaining "Other Fish"

maxn <- maxn |> 
  filter(!(MaxN == 0 & Species == "Other Fish"))
