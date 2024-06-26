#downloading and cleanning SA Building Permits data

library(data.table)
building_permits_sa <- fread("https://data.sanantonio.gov/dataset/05012dcb-ba1b-4ade-b5f3-7403bc7f52eb/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512/download/permits_issued.csv") 

head(building_permits_sa)

# ggplot()+
#   geom_point(data=building_permits_sa,aes(x=X_COORD,y=Y_COORD))

building_permits_sa[!is.na(X_COORD),]
building_permits_sa[!is.na(X_COORD),summary(X_COORD)]

building_permits_sa <- building_permits_sa[!is.na(X_COORD) & X_COORD>100000 & Y_COORD>10000000,] # keeps 7813 obs out of 8886
building_permits_sa[,year_issued:=year(`DATE ISSUED`)]
building_permits_sa[,year_submitted:=year(`DATE SUBMITTED`)]


# ggplot()+
#   geom_point(data=building_permits_sa,aes(x=X_COORD,y=Y_COORD))
# 
# ggplot()+
#   geom_point(data=building_permits_sa,aes(x=X_COORD,y=Y_COORD))+
#   geom_sf(data = bexar_tracts) # produces error, different CRS (coordinate reference system)

