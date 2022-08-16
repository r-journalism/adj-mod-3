library(tidyverse)
library(lubridate)

url <-"https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv"

confirmed <- read_csv(url)

confirmed_long <- confirmed %>% 
  pivot_longer(cols=`1/22/20`:ncol(confirmed), names_to="date", values_to="confirmed") %>% 
  mutate(date=mdy(date)) %>% 
  group_by(Country_Region, date) %>% 
  summarize(confirmed=sum(confirmed, na.rm=T)) %>% 
  mutate(daily=confirmed - lag(confirmed, 1))

for (i in 2020:2022) {
  for (x in 1:12) {
    if (nchar(x)==1) {
      month <- paste0("0", x)
    } else {
      month <- as.character(x)
    }
    
    df <- filter(confirmed_long,
                 year(date)==i & month(date)==x)
    
    write_csv(df, paste0("covid_data/", i, "-", month, ".csv"), na="")
    print(paste0("covid_data/", i, "-", month))
  }
}
