######## aggiusto dati terna per poterli usare nei tutorial ###############


### apertura librerie ###

library(tidyverse)
library(lubridate)

### apertura dati ###

terna16 <- read.csv("terna_data/2016.csv", sep=";")[,-1]
terna17 <- read.csv("terna_data/2017.csv", sep=";")[,-1]
terna18 <- read.csv("terna_data/2018.csv", sep=";")[,-1]
terna19 <- read.csv("terna_data/2019.csv", sep=";")[,-1]
terna20 <- read.csv("terna_data/2020.csv", sep = ";")[,-1]
terna21 <- read.csv("terna_data/2021.csv", sep=";")[,-1]
  
### modifica ###

terna_all <- rbind(terna16,terna17,terna18,terna19,terna20,terna21) %>% 
  rename(generation.GWh = Renewable.Generation..GWh., 
         source = Energy.Source) %>% 
  mutate(generation.GWh =as.numeric(gsub(",",".",generation.GWh)),
         Date = dmy_hm(Date), 
         Month = format(Date, format="%m"), 
         Day = format(Date, format="%d"),
         Year = as.numeric(format(Date, format="%Y")))

daily_avg <- terna_all %>%
  group_by(Day, Month, Year, source) %>% 
  summarise(generation_avg_daily = round(mean(generation.GWh), 7)) %>% 
  spread(source,generation_avg_daily) %>% 
  mutate(date = dmy(paste(Day, Month, Year, sep="/"))) %>% 
  ungroup() %>%
  select(-Day,-Month) %>% 
  arrange(date)

str(daily_avg)

terna16 <-filter(daily_avg, Year == 2016)
terna17 <-filter(daily_avg, Year==2017)
terna18<-filter(daily_avg,Year==2018)
terna19 <-filter(daily_avg, Year==2019)
terna20<-filter(daily_avg,Year==2020)
terna21 <- filter(daily_avg, Year==2021)


### scrittura in .csv ### 

write.csv(terna16, "terna_data/terna16.csv")
write.csv(terna17, "terna_data/terna17.csv")
write.csv(terna18, "terna_data/terna18.csv")
write.csv(terna19, "terna_data/terna19.csv")
write.csv(terna20, "terna_data/terna20.csv")
write.csv(terna21, "terna_data/terna21.csv")

