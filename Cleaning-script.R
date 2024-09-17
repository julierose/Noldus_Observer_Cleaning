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

#this code separates the observation column into individual attributes, selects
#only the behavior data (no abundance data), renames columns to make them more 
#informative, drops unnecessary columns, and removes the extra "_imported" text 
#in the behavior column
behavior <- obs_import %>%
  separate_wider_delim(cols = Observation, delim = "_", 
                       names = c("Analyst", "Date", "Treatment", "Replicate",
                                 "Camera_Numbers", "Hour")) %>%
  mutate_at(c("Subject", "Behavior", "Modifier_2", "Treatment", "Replicate", 
              "Hour"), as.factor) %>%
  mutate(Date = mdy(Date)) %>%
  filter(Subject != "Subject", Behavior != "NA") %>%
  rename(Location_on_structure = Modifier_2, Species = Subject, 
         Behavior_Time = Time_Relative_sf) %>%
  select(!c(Date_Time_Absolute_dmy_hmsf, Date_dmy, Time_Absolute_hms, 
            Time_Absolute_f, Time_Relative_hmsf, Time_Relative_hms, 
            Time_Relative_f, Duration_sf, Event_Log, Modifier_1, Event_Type)) %>%
  mutate(Behavior = gsub("_.*","", Behavior)) %>%
  arrange(Species, Behavior, Replicate)