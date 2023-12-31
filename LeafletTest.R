#12/14/23, initiated by BS
#Goal:  To map the different urban/suburban landscapes of Richmond
#Scripts purpose is to plot/map the urban and suburban and examine how the spatial extent compares

#Libraries
library(tidyverse)
library(sf)
library(mapview)

#Create a filepath to OneDrive
onedrivepath="~/OneDrive - The Pennsylvania State University/"

#Load in Landscape data
#By year

#2020
Political <- read_sf(paste0(onedrivepath, "Mapping Richmond/Political/Political_2020/Political_2020.shp")) 

BuildingAge <- read_sf(paste0(onedrivepath, "Mapping Richmond/Building Age/Building_Age_2020/Building_Age_2020.shp")) %>%
  rename(Landscape = Landscp,
         State_Name = Stat_Nm)

Homeownership <- read_sf(paste0(onedrivepath, "Mapping Richmond/Homeownership/Homeownership_2020/Homeownership_2020.shp")) %>%
  rename(State_Name = Stat_Nm,
         Total_Units = Ttl_Unt,
         Owner_Occupied = Ownr_Oc,
         Total_Rented  = Ttl_Rnt,
         OwnerOccupied_Percent = OwnrO_P,
         Rented_Percent = Rntd_Pr,
         Median_Ownership = Mdn_Own,
         Definition = Defintn) 

BuildingDensity <- read_sf(paste0(onedrivepath, "Mapping Richmond/Building Density/BuildingDensity_2020/BuildingDensity_2020.shp")) %>%
  rename(State_Name = Stat_Nm,
         Landscape = Landscp,
         Area_Miles2 = Ar_Mls2,
         Pre1940_Density = P1940_D,
         InnerRing_Density = InnrR_D)

PopulationDensity <- read_sf(paste0(onedrivepath, "Mapping Richmond/Population Density/PopulationDensity_2020/PopulationDensity_2020.shp")) %>%
  rename(State_Name = Stat_Nm,
         #Landscp = Landscp,
         Area_Miles2 = Ar_Mls2,
         Pop_Density = Ppltn_D,
         Definition = Defintn,
         YEAR = Year)

Distance <- read_sf(paste0(onedrivepath, "Mapping Richmond/Distance/Distance_2020/Distance_2020.shp")) %>%
  rename(State_Name = Stat_Nm,
         Landscape = Landscp,
         Petersburg = Ptrsbrg,
         'Colonial Heights' = ClnlHgh,
         Hopewell = Hopewll,
         Richmond = Richmnd,
         Definition = Defintn,
         YEAR = Year)

Travel <- read_sf(paste0(onedrivepath, "Mapping Richmond/Travel/Travel_2020/Travel_2020.shp")) %>%
  rename(State_Name = Stat_Nm,
         #Landscape = Landscp,
         Car_Percent = Cr_Prcn,
         Active_Percent = Actv_Pr,
         PubTransp_Percent = PbTrn_P,
         Population_Density = Ppltn_D,
         Definition = Defintn)

#Interactive mapping
install.packages("mapboxapi")
library(mapboxapi)

mb_access_token("pk.eyJ1IjoiYnNvdXRoZXJuIiwiYSI6ImNrdzVtdm9tZjJybTgydnBhaGFqb3I3aHUifQ.FfF00w4hPTtLFckINVxasA", install = TRUE)








Travel <- st_transform(Travel, 4326)
Homeownership <- st_transform(Homeownership, 4326)
PopulationDensity <- st_transform(PopulationDensity, 4326)
BuildingAge <- st_transform(BuildingAge, 4326)
BuildingDensity <- st_transform(BuildingDensity, 4326)
Distance <- st_transform(Distance, 4326)
Political <- st_transform(Political, 4326)




# Create the map 
leaflet() %>%
  addTiles() %>%
  #Building Age
  addPolygons(
    data = BuildingAge,
    fillColor = ~colorFactor(
      palette = c("lightgrey", "#8da0cb", "#fc8d62", "black"),
      levels = c("No housing", "Post-Civil Rights", "Pre-Civil Rights", "Urban"),
      domain = unique(BuildingAge$Landscape)
    )(Landscape),
    color = "white",
    fillOpacity = 0.5,
    weight = 1,
    highlightOptions = highlightOptions(
      color = "black",
      fillOpacity = 1,
      weight = 2
    ),
    group = "Building Age",
    label = ~BuildingAge$Landscape
  ) %>%
  addLegend(
    position = "bottomleft",
    pal = colorFactor(
      palette = c("lightgrey", "#8da0cb", "#fc8d62", "black"),
      levels = c("No housing", "Post-Civil Rights", "Pre-Civil Rights", "Urban"),
      domain = unique(BuildingAge$Landscape)
    ),
    values = BuildingAge$Landscape,
    title = "Building Age",
    group = "Building Age"
  ) %>%
  #Building Density 
  addPolygons(
    data = BuildingDensity,
    fillColor = ~colorFactor(
      palette = c("#e78ac3", "#8da0cb", "black"),
      levels = c("Inner Suburb", "Outer Suburb", "Urban"),
      domain = unique(BuildingAge$Landscape)
    )(Landscape),
    color = "white",
    fillOpacity = 0.5,
    weight = 1,
    highlightOptions = highlightOptions(
      color = "black",
      fillOpacity = 1,
      weight = 2
    ),
    group = "Building Density",
    label = ~BuildingDensity$Landscape
  ) %>%
  addLegend(
    position = "bottomleft",
    pal = colorFactor(
      palette = c("#e78ac3", "#8da0cb", "black"),
      levels = c("Inner Suburb", "Outer Suburb", "Urban"),
      domain = unique(BuildingAge$Landscape)),
      values = BuildingDensity$Landscape,
    title = "Building Density",
    group = "Building Density",
  ) %>%
  #Distance urban/suburban
  addPolygons(
    data = Distance,
    fillColor = ~colorFactor(
      palette = c("#bd0026", "#f03b20", "#fd8d3c", "#fecc5c"),
      levels = c("Urban Core", "Inner-Urban", "Inner-Suburban", "Outer-Suburban"),
      domain = unique(Distance$Landscape)
    )(Landscape),
    color = "white",
    fillOpacity = 0.5,
    weight = 1,
    highlightOptions = highlightOptions(
      color = "black",
      fillOpacity = 1,
      weight = 2
    ),
    group = "Distance",
    label = ~Distance$Landscape
  ) %>%
  addLegend(
    position = "bottomleft",
    pal = colorFactor(
      palette = c("#bd0026", "#f03b20", "#fd8d3c", "#fecc5c"),
      levels = c("Urban Core", "Inner-Urban", "Inner-Suburban", "Outer-Suburban"),
      domain = unique(Distance$Landscape)),
    values = Distance$Landscape,
    title = "Distance",
    group = "Distance",
  ) %>%
  #Homeownership 
  addPolygons(
    data = Homeownership,
    fillColor = ~colorFactor("Set2", domain = unique(Homeownership$Landscp))(Landscp),
    color = "white",
    fillOpacity = 0.5,
    weight = 1,
    highlightOptions = highlightOptions(
      color = "black",
      fillOpacity = 1,
      weight = 2
    ),
    group = "Homeownership",
    label = ~Homeownership$Landscp
  ) %>%
  addLegend(
    position = "bottomleft",
    pal = colorFactor("Set2", domain = unique(Homeownership$Landscp)),
    values = Homeownership$Landscp,
    title = "Homeownership",
    group = "Homeownership",
  ) %>%
  #Political urban/suburban
  addPolygons(
    data = Political,
    fillColor = ~colorFactor(
      palette = c("#d9d9d9", "#636363"),
      levels = c("Suburban", "Urban"),
      domain = unique(Political$Landscape)
    )(Landscape),
    color = "white",
    fillOpacity = 0.5,
    weight = 1,
    highlightOptions = highlightOptions(
      color = "black",
      fillOpacity = 1,
      weight = 2
    ),
    group = "Political",
    label = ~Political$Landscape
  ) %>%
  addLegend(
    position = "bottomright",
    pal = colorFactor(
      palette = c("#d9d9d9", "#636363"),
      levels = c("Suburban", "Urban"),
      domain = unique(Political$Landscape)),
    values = Political$Landscape,
    title = "Political",
    group = "Political",
  ) %>%
  #Population Density urban/suburban
  addPolygons(
    data = PopulationDensity,
    fillColor = ~colorFactor(
      palette = c("#b2182b", "#d6604d", "#f4a582", "#fddbc7", "#F2F2F2", "black", "#999999"),
      levels = c("High-Density Suburban", "Mid-Density Suburban", "Low-Density Suburban", 
                 "Exurban", "No Population", "High-Density Urban", "Low-Density Urban"),
      domain = unique(PopulationDensity$Landscp)
    )(Landscp),
    color = "white",
    fillOpacity = 0.5,
    weight = 1,
    highlightOptions = highlightOptions(
      color = "black",
      fillOpacity = 1,
      weight = 2
    ),
    group = "Population Density",
    label = ~PopulationDensity$Landscp
  ) %>%
  addLegend(
    position = "bottomright",
    pal = colorFactor(
      palette = c("#b2182b", "#d6604d", "#f4a582", "#fddbc7", "#F2F2F2", "black", "#999999"),
      levels = c("High-Density Suburban", "Mid-Density Suburban", "Low-Density Suburban", 
                 "Exurban", "No Population", "High-Density Urban", "Low-Density Urban"),
      domain = unique(PopulationDensity$Landscp)
    ),
    values = PopulationDensity$Landscp,
    title = "Population Density",
    group = "Population Density"
  ) %>%
  #Travel urban/suburban
  addPolygons(
    data = Travel,
    fillColor = ~colorFactor("Set1", domain = unique(Travel$Landscp))(Landscp),
    color = "white",
    fillOpacity = 0.5,
    weight = 1,
    highlightOptions = highlightOptions(
      color = "black",
      fillOpacity = 1,
      weight = 2
    ),
    group = "Travel",
    label=~Travel$Landscp
  ) %>%  
  addLegend(
    position = "bottomright",
    pal = colorFactor("Set1", domain = unique(Travel$Landscp)),
    values = Travel$Landscp,
    title = "Travel",
    group = "Travel"
  ) %>%
  #Layer control
  #addProviderTiles("Jawg_Streets", group = "Jawg_Streets") %>%
  # addProviderTiles("Jawg_Streets", group = "Jawg_Streets") %>%
  addLayersControl(
    baseGroups = c("Jawg_Streets"),
    overlayGroups = c("Building Age", "Building Density", "Distance","Homeownership", 
                      "Political", "Population Density", "Travel"),
    options = layersControlOptions(collapsed = FALSE, hideSingleBase = F)) 


