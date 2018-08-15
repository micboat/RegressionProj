library(tidyverse)

nb_data_csv <- read_csv("nb_data.csv")


# Experiments - can be deleted




#Delete above

# Convert price from word to numbers

nb_data <- nb_data_csv %>% 
  separate(Price, c("Amt", "word"), sep = " ") %>% 
  mutate(wordtonum = 
           case_when(
             word == "Crores" ~ 10000000,
             word == "Crore" ~ 10000000,
             word == "Lacs" ~ 100000,
             word == "K" ~ 1000
           )) %>% 
  mutate(Amount = as.numeric(Amt) * wordtonum) %>% 
  select(-Amt, -word, -wordtonum) %>% 
  select(-Measure, -Verified, -LoanVerified, -SaleType, -MonthlyEMI) %>%
  select(-Address, -PostedTime, -ShortAddress, -Area2) %>% 
  separate(Bathrooms , c("NoofBathrooms", "Delete")) %>% 
  select(-Delete) %>% 
  # separate(MonthlyEMI, c("figure", "word"), sep = " ") %>% 
  # mutate(wordtonum = 
  #          case_when(
  #            word == "/Month" ~ 1,
  #            word == "K/Month" ~ 1000,
  #            word == "Lacs/Month" ~ 100000
  #          )) %>% 
  # mutate(MonthlyEMI = as.numeric(figure) * wordtonum) %>% 
  # select(-figure, -word, - wordtonum) %>% 
  separate(Balconies, c("NoofBalconies", "Delete"), sep = " ") %>% 
  select(-Delete) %>% 
  separate(Maintanance, c("Maint_sqft", "delete1", "delete2"), sep = " ") %>% 
  select(-delete1, -delete2) %>% 
  mutate_at("Maint_sqft", as.numeric) %>% 
  filter(Area < 1283800) # temp

#no of bedrooms, floor, HomeType


