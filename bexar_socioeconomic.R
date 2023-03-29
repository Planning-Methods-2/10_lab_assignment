#bexar_socioeconomic
library(tidycensus)

census_api_key("0d539976d5203a96fa55bbf4421110d4b3db3648")# you must acquired your own key at http://api.census.gov/data/key_signup.html

bexar_medincome_15 <- get_acs(geography = "tract", variables = "B19013_001",
                              state = "TX", county = "Bexar", geometry = TRUE,year = 2020)
bexar_medincome_20 <- get_acs(geography = "tract", variables = "B19013_001",
                              state = "TX", county = "Bexar", geometry = FALSE,year = 2021)

bexar_homevalue_15 <- get_acs(geography = "tract", variables = "B25077_001",
                              state = "TX", county = "Bexar", geometry = TRUE,year = 2020)
bexar_homevalue_20 <- get_acs(geography = "tract", variables = "B25077_001",
                              state = "TX", county = "Bexar", geometry = FALSE,year = 2021)

names(bexar_homevalue_15)[names(bexar_homevalue_15)%in%c("estimate","moe")] <-c("estimate_mhv_15","moe_mhv_15")
names(bexar_homevalue_20)[names(bexar_homevalue_20)%in%c("estimate","moe")] <-c("estimate_mhv_20","moe_mhv_20")

names(bexar_medincome_15)[names(bexar_medincome_15)%in%c("estimate","moe")] <-c("estimate_mhi_15","moe_mhi_15")
names(bexar_medincome_20)[names(bexar_medincome_20)%in%c("estimate","moe")] <-c("estimate_mhi_20","moe_mhi_20")

#Merging data
bexar_mhv<-merge(bexar_homevalue_15,bexar_homevalue_20,by="GEOID",sort = F)
bexar_mhi<-merge(bexar_medincome_15,bexar_medincome_20,by="GEOID",sort = F)

#Calculating the percentage change
bexar_mhv$mhv_per_change<-round(((bexar_mhv$estimate_mhv_20/bexar_mhv$estimate_mhv_15)-1),2)
bexar_mhi$mhi_per_change<-round(((bexar_mhi$estimate_mhi_20/bexar_mhi$estimate_mhi_15)-1),2)

bexar_mhv<-as.data.table(bexar_mhv)
bexar_mhv<-bexar_mhv[,.(GEOID,estimate_mhv_15,estimate_mhv_20,mhv_per_change)]

bexar_socioeconomic<-merge(x = bexar_mhi,y = bexar_mhv,by="GEOID",sort=F)

rm(bexar_homevalue_15,bexar_homevalue_20,bexar_medincome_15,bexar_medincome_20)
rm(bexar_mhi,bexar_mhv)
