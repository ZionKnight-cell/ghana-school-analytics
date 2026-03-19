# 03_visualize.R
# Visualizations for Ghana education data

library(tidyverse)

# Load cleaned data
ghana <- read_csv("data/processed/ghana_education_clean.csv")

# ── Chart 1: Primary vs Secondary Enrollment over time ──────────────────

enrollment_long <- ghana %>%
  select(year, enrollment_primary, enrollment_secondary) %>%
  pivot_longer(
    cols      = c(enrollment_primary, enrollment_secondary),
    names_to  = "level",
    values_to = "enrollment"
  ) %>%
  mutate(level = recode(level,
                        "enrollment_primary"   = "Primary",
                        "enrollment_secondary" = "Secondary"
  ))

ggplot(enrollment_long, aes(x = year, y = enrollment, colour = level)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  labs(
    title    = "Ghana School Enrollment Rates (2000–2023)",
    subtitle = "Gross enrollment rate (%) by education level",
    x        = "Year",
    y        = "Enrollment Rate (%)",
    colour   = "Level",
    caption  = "Source: World Bank WDI"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

# ── Chart 2: Gender Gap in Primary Enrollment ────────────────────────────

gender_long <- ghana %>%
  select(year, enrollment_primary_f, enrollment_primary_m) %>%
  pivot_longer(
    cols      = c(enrollment_primary_f, enrollment_primary_m),
    names_to  = "gender",
    values_to = "enrollment"
  ) %>%
  mutate(gender = recode(gender,
                         "enrollment_primary_f" = "Female",
                         "enrollment_primary_m" = "Male"
  ))

ggplot(gender_long, aes(x = year, y = enrollment, colour = gender)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  scale_colour_manual(values = c("Female" = "#E91E8C", "Male" = "#1E90FF")) +
  labs(
    title    = "Gender Gap in Primary Enrollment — Ghana",
    subtitle = "Are boys and girls equally in school?",
    x        = "Year",
    y        = "Enrollment Rate (%)",
    colour   = "Gender",
    caption  = "Source: World Bank WDI"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

# ── Chart 3: Out-of-school children over time ────────────────────────────

ghana %>%
  filter(!is.nan(out_of_school)) %>%
  ggplot(aes(x = year, y = out_of_school)) +
  geom_col(fill = "#E74C3C", alpha = 0.8) +
  labs(
    title   = "Out-of-School Children Rate — Ghana (2000–2023)",
    subtitle = "% of primary school age children not in school",
    x       = "Year",
    y       = "Out-of-School Rate (%)",
    caption = "Source: World Bank WDI"
  ) +
  theme_minimal()

# ── Chart 4: Pupil-Teacher Ratio over time ───────────────────────────────

ghana %>%
  filter(!is.nan(pupil_teacher_ratio)) %>%
  ggplot(aes(x = year, y = pupil_teacher_ratio)) +
  geom_line(linewidth = 1.2, colour = "#2ECC71") +
  geom_hline(yintercept = 40, linetype = "dashed", colour = "red") +
  annotate("text", x = 2001, y = 41, label = "UNESCO threshold (40)", 
           colour = "red", size = 3) +
  labs(
    title   = "Pupil-Teacher Ratio — Ghana Primary Schools",
    subtitle = "Number of pupils per teacher",
    x       = "Year",
    y       = "Pupils per Teacher",
    caption = "Source: World Bank WDI"
  ) +
  theme_minimal()

# ── Save all charts ───────────────────────────────────────────────────────

# Re-run each chart assigned to a variable
p1 <- ggplot(enrollment_long, aes(x = year, y = enrollment, colour = level)) +
  geom_line(linewidth = 1.2) + geom_point(size = 2) +
  labs(title = "Ghana School Enrollment Rates (2000–2023)",
       subtitle = "Gross enrollment rate (%) by education level",
       x = "Year", y = "Enrollment Rate (%)", colour = "Level",
       caption = "Source: World Bank WDI") +
  theme_minimal() + theme(legend.position = "bottom")

p2 <- ggplot(gender_long, aes(x = year, y = enrollment, colour = gender)) +
  geom_line(linewidth = 1.2) + geom_point(size = 2) +
  scale_colour_manual(values = c("Female" = "#E91E8C", "Male" = "#1E90FF")) +
  labs(title = "Gender Gap in Primary Enrollment — Ghana",
       subtitle = "Are boys and girls equally in school?",
       x = "Year", y = "Enrollment Rate (%)", colour = "Gender",
       caption = "Source: World Bank WDI") +
  theme_minimal() + theme(legend.position = "bottom")

p3 <- ghana %>% filter(!is.nan(out_of_school)) %>%
  ggplot(aes(x = year, y = out_of_school)) +
  geom_col(fill = "#E74C3C", alpha = 0.8) +
  labs(title = "Out-of-School Children Rate — Ghana (2000–2023)",
       subtitle = "% of primary school age children not in school",
       x = "Year", y = "Out-of-School Rate (%)",
       caption = "Source: World Bank WDI") +
  theme_minimal()

p4 <- ghana %>% filter(!is.nan(pupil_teacher_ratio)) %>%
  ggplot(aes(x = year, y = pupil_teacher_ratio)) +
  geom_line(linewidth = 1.2, colour = "#2ECC71") +
  geom_hline(yintercept = 40, linetype = "dashed", colour = "red") +
  annotate("text", x = 2001, y = 41, label = "UNESCO threshold (40)",
           colour = "red", size = 3) +
  labs(title = "Pupil-Teacher Ratio — Ghana Primary Schools",
       subtitle = "Number of pupils per teacher",
       x = "Year", y = "Pupils per Teacher",
       caption = "Source: World Bank WDI") +
  theme_minimal()

# Save to outputs/
ggsave("outputs/01_enrollment_trends.png",  p1, width = 8, height = 5, dpi = 150)
ggsave("outputs/02_gender_gap.png",         p2, width = 8, height = 5, dpi = 150)
ggsave("outputs/03_out_of_school.png",      p3, width = 8, height = 5, dpi = 150)
ggsave("outputs/04_pupil_teacher_ratio.png",p4, width = 8, height = 5, dpi = 150)

message("✅ All charts saved to outputs/")

# ── Chart 5: West Africa Regional Comparison ─────────────────────────────
library(ghanaedur)

wa_data <- get_west_africa_education()
p5 <- plot_regional_comparison(wa_data)
p5
ggsave("outputs/05_regional_comparison.png", p5, width = 8, height = 5, dpi = 150)