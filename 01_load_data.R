# 01_load_data.R
# Pull Ghana education data from the World Bank API

install.packages("WDI")
library(WDI)
library(tidyverse)

# Define indicators we want
indicators <- c(
  enrollment_primary     = "SE.PRM.ENRR",    # Primary enrollment rate (gross %)
  enrollment_secondary   = "SE.SEC.ENRR",    # Secondary enrollment rate (gross %)
  enrollment_primary_f   = "SE.PRM.ENRR.FE", # Primary enrollment - female
  enrollment_primary_m   = "SE.PRM.ENRR.MA", # Primary enrollment - male
  pupil_teacher_ratio    = "SE.PRM.TCHR.FE", # Pupil-teacher ratio, primary
  out_of_school          = "SE.PRM.UNER.ZS", # Out-of-school children (%)
  literacy_rate          = "SE.ADT.LITR.ZS"  # Adult literacy rate (%)
)

# Pull Ghana data (country code = "GH")
ghana_edu <- WDI(
  country   = "GH",
  indicator = indicators,
  start     = 2000,
  end       = 2023,
  extra     = TRUE  # adds region, income level, etc.
)

# Quick look
glimpse(ghana_edu)

# Save raw data
write_csv(ghana_edu, "data/raw/ghana_education_raw.csv")

message("✅ Data loaded and saved to data/raw/")