# Load in required libraries and data
library(tidyverse)
library(here)

data <- read.csv(
  here("Data", "Deidentified Raw Data", "Study4_Deidentified_Data.csv")
)

# Retain data from participants who passed attention checks
data <- data %>%
  filter(Attn_Check_Never == 5) %>%
  filter(Attn_Check_Much == 2) %>%
  select(-contains("Attn"))

# Convert to long format and match experience/expression with connection
TidyData <- data %>%
  pivot_longer(
    cols = contains(c("Experience", "Expression")),
    names_to = "Exp_Type",
    values_to = "Frequency"
  )%>%
  pivot_longer(
    cols = contains("Conn"),
    names_to = "Type.2",
    values_to = "Connection"
  ) %>%
  filter(substr(Exp_Type, 1, 7) == substr(Type.2, 1, 7))

# Match with draw close or distance
TidyData <- TidyData %>%
  pivot_longer(
    cols = contains("Dist"),
    names_to = "Type.3",
    values_to = "DrawClose"
  ) %>%
  filter(substr(Type.2, 1, 7) == substr(Type.3, 1, 7))

# Match with affirming or undermining
TidyData <- TidyData %>%
  pivot_longer(
    cols = contains("Afrm"),
    names_to = "Type.4",
    values_to = "Affirming"
  ) %>%
    filter(substr(Type.3, 1, 7) == substr(Type.4, 1, 7))

# Match with willing
TidyData <- TidyData %>%
  pivot_longer(
    cols = contains("Want"),
    names_to = "Type.5",
    values_to = "Willing"
  ) %>%
  filter(substr(Type.4, 1, 7) == substr(Type.5, 1, 7))

# Keep matching recall and hypothetical
TidyData <- TidyData %>%
  filter(substr(Type.2, 14, 14) == substr(Type.3, 14, 14)) %>%
  filter(substr(Type.3, 14, 14) == substr(Type.4, 14, 14))

# Create predictor variables
TidyData <- TidyData %>%
  mutate(Relationship = substr(Exp_Type, 1,2)) %>%
  mutate(Emotion = substr(Exp_Type, 4, 7)) %>%
  mutate(Relationship_Type = case_when(Relationship == "RP" ~ "Communal",
                                       Relationship == "CF" ~ "Communal",
                                       Relationship == "CC" ~ "Transactional",
                                       Relationship == "SS" ~ "Transactional"
                                       )) %>%
  mutate(Exp_Type = substr(Exp_Type, 9, length(Exp_Type))) %>%
  mutate(Hyp_Recall = substr(Type.2, 14, length(Type.2))) %>%
  mutate(Emotion = case_when(Emotion == "Hurt" ~ "Hurt",
                              Emotion == "Joys" ~ "Joy",
                              Emotion == "Love" ~ "Love",
                              Emotion == "Sadn" ~ "Sadness")) %>%
  select(-Type.2, -Type.3, -Type.4, -Type.5) %>%
  arrange(PID, Relationship_Type, Relationship, Emotion, Exp_Type) %>%
  select(PID, Relationship_Type, Relationship, Emotion, Exp_Type, Frequency,
         Hyp_Recall, Connection, DrawClose, Affirming, Willing, everything())

# Create dependent variables
TidyData <- TidyData %>%
  mutate(Frequency = 5 - Frequency) %>%
  mutate(Connection = 3 - Connection) %>%
  mutate(DrawClose = 3 - DrawClose) %>%
  mutate(Affirming = 3 - Affirming) %>%
  mutate(Willing = 3 - Willing) %>%
  mutate(Age_4_TEXT = as.numeric(substr(Age_4_TEXT, 1, 2)))

# Save data to csv
write.csv(
  TidyData,
  here("Data", "Analysis-Ready Data", "Study4_AnalysisData.csv"),
  row.names = FALSE
)
