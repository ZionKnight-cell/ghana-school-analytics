# 02_clean_data.R
# Clean and process the raw Ghana education data

library(tidyverse)
library(janitor)

# Load raw data
ghana_raw <- read_csv("data/raw/ghana_education_raw.csv")

# Fix 1: Remove duplicate rows (keep one row per year)
ghana_clean <- ghana_raw %>%
  group_by(year) %>%
  summarise(
    enrollment_primary   = mean(enrollment_primary, na.rm = TRUE),
    enrollment_secondary = mean(enrollment_secondary, na.rm = TRUE),
    enrollment_primary_f = mean(enrollment_primary_f, na.rm = TRUE),
    enrollment_primary_m = mean(enrollment_primary_m, na.rm = TRUE),
    out_of_school        = mean(out_of_school, na.rm = TRUE),
    literacy_rate        = mean(literacy_rate, na.rm = TRUE)
  ) %>%
  ungroup()

# Fix 2: Replace the wrong pupil_teacher_ratio with correct indicator
library(WDI)
ptr <- WDI(
  country   = "GH",
  indicator = c(pupil_teacher_ratio = "SE.PRM.ENRL.TC.ZS"),
  start     = 2000,
  end       = 2023
)

# Join it in
ghana_clean <- ghana_clean %>%
  left_join(ptr %>% select(year, pupil_teacher_ratio), by = "year")

# Quick look
glimpse(ghana_clean)
summary(ghana_clean)

# Save cleaned data
write_csv(ghana_clean, "data/processed/ghana_education_clean.csv")

message("✅ Cleaned data saved to data/processed/")