# Load in required libraries and data
library(tidyverse)
library(here)

data <- read_csv(
  here("Data", "Deidentified Raw Data", "Study1_Deidentified_Data.csv"),
  show_col_types = FALSE
)

# Retain data from participants who passed attention checks
data <- data %>%
  filter(Attn_Check_Never == 5) %>%
  filter(Attn_Check_Much == 2) %>%
  select(-contains("Attn"))

# Convert to long format
TidyData <- data %>%
  pivot_longer(
    cols = contains(c("Experience", "Expression")),
    names_to = "Type",
    values_to = "Frequency"
  ) %>%
  pivot_longer(
    cols = contains("Connection"),
    names_to = "Type.2",
    values_to = "Connection"
  ) %>%
  # Only keeping rows with matching contexts for connection and frequency
  filter(substr(Type, 1, 6) == substr(Type.2, 1, 6))

# Dividing `Type` variable into `Emotion` and `Relationship` and changing values
# to have more meaningful labels
TidyData <- TidyData %>%
  mutate(Emotion = substr(Type, 1, 2)) %>%
  mutate(Relationship = substr(Type, 4, 5)) %>%
  mutate(Type = substr(Type, 7, length(Type))) %>%
  mutate(Emotion = case_when(
    Emotion == "X1" ~ "Respect",
    Emotion == "X2" ~ "Pride",
    Emotion == "X3" ~ "Guilt",
    Emotion == "X4" ~ "Anger")) %>%
  mutate(
    Orientation = case_when(
      Emotion == "Respect" ~ "Engaging",
      Emotion == "Pride" ~ "Disengaging",
      Emotion == "Guilt" ~ "Engaging",
      Emotion == "Anger" ~ "Disengaging"
    ),
    Valence = case_when(
      Emotion == "Respect" ~ "Positive",
      Emotion == "Pride" ~ "Positive",
      Emotion == "Guilt" ~ "Negative",
      Emotion == "Anger" ~ "Negative"
    )) %>%
  mutate(Relationship = case_when(
    Relationship == "RP" ~ "Romantic Partner",
    Relationship == "CF" ~ "Close Friend",
    Relationship == "CC" ~ "Classmate/Colleague",
    Relationship == "St" ~ "Stranger"
  )) %>%
  mutate(Relationship_Type = case_when(
    Relationship == "Romantic Partner" ~ "Communal",
    Relationship == "Close Friend" ~ "Communal",
    Relationship == "Classmate/Colleague" ~ "Transactional",
    Relationship == "Stranger" ~ "Transactional"
  )) %>%
  mutate(Frequency = 5 - Frequency) %>%
  mutate(Connection = 3 - Connection) %>%
  mutate(Age = as.numeric(Age))

# Remove unnecessary columns and rearrange others. Sort by meaningful variables
TidyData <- TidyData %>%
  select(-matches("Type.2")) %>%
  select(PID, Relationship_Type, Relationship, Orientation, Emotion,
         Valence, Type, Frequency, Connection, Sex, Age, Language,
         Ethnicity.simplified, Nationality, Country.of.residence,
         Country.of.birth, Relationship.marital.status, Student.status,
         Employment.status) %>%
  arrange(PID, Relationship_Type, Relationship, Orientation, Emotion)

# Create df to combine with study 2
Study1 <- TidyData %>%
  mutate(PE = "Expression") %>%
  select(PID, PE, Relationship_Type, Relationship, Orientation, Emotion, Valence, Type, Frequency, Connection)

# Save main data to csv
write.csv(
  TidyData,
  here("Data", "Analysis-Ready Data", "Study1_AnalysisData.csv"),
  row.names = FALSE
)

# Save data for comparison to study 2 to csv
write.csv(
  Study1,
  here("Data", "Analysis-Ready Data", "Study1_ComparisonData.csv"),
  row.names = FALSE
)
