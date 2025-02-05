# Lab 2 Script: Loading data and the grammar of graphics (ggplot2)
# The University of Texas at San Antonio
# URP-5393: Urban Planning Methods II


#---- Objectives ----
# In this Lab you will learn to:

# 1. Load datasets into your R session -> open the `Lab2_script.R` to go over in class.
# 2. Learn about the different ways `R` can plot information
# 3. Learn about the usage of the `ggplot2` package


#---- Part 1: Loading data ----

# Data can be loaded in a variety of ways. As always is best to learn how to load using base functions that will likely remain in time so you can go back and retrace your steps. 
# This time we will load two data sets in three ways.


## ---- Part 1.1: Loading data from R pre-loaded packages ----

data() # shows all preloaded data available in R in the datasets package
help(package="datasets") #brings up the help page for the "datasets" package

#Let's us the Violent Crime Rates by US State data 

help("USArrests") #brings up the help page for the dataset called USArrests

# Step 1. Load the data in you session by creating an object

usa_arrests<-datasets::USArrests # this looks the object 'USAarrests' within '::' the package 'datasets'

class(usa_arrests) #tells you what class of data the object is
names(usa_arrests) #lists the names of the columns in the dataframe object
dim(usa_arrests) #tells you the dimensions of the dataframe object (50 rows, 4 columns)
head(usa_arrests) #brings up the first six rows of the dataframe
tail(usa_arrests) #brings up the last six rows of the dataframe

## ---- Part 1.2: Loading data from your computer directory ----
# We will use the Building Permits data from the city of San Antonio open data portal
# Source: https://data.sanantonio.gov/dataset/building-permits/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512

building_permits_sa<-read.csv(file = "datasets/accelaissuedpermitsextract.csv",header = T) #creates an object based on the file being loaded from wherever it's saved on your computer 

names(building_permits_sa) #lists the names of the columns in the dataframe
View(building_permits_sa) #jumps to view the open tab of the object
class(building_permits_sa) #tells you what class of data the object is
dim(building_permits_sa) #tells you the dimensions of the dataframe 
str(building_permits_sa) #shows you the internal structure of the object 
summary(building_permits_sa) #shows a summary of the data in the dataframe like the length of each column and some summary statistics


## ---- Part 1.3: Loading data directly from the internet ----
# We will use the Building Permits data from the city of San Antonio open data portal
# Source: https://data.sanantonio.gov/dataset/building-permits/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512

building_permits_sa2 <- read.csv("https://data.sanantonio.gov/dataset/05012dcb-ba1b-4ade-b5f3-7403bc7f52eb/resource/c21106f9-3ef5-4f3a-8604-f992b4db7512/download/accelaissuedpermitsextract.csv",header = T) #creates an object based on the file being loaded from the url  




## ---- Part 1.4: Loading data using a package + API ----
#install.packages("tidycensus")
#install.packages("tigris")
help(package="tidycensus") #opens help page for the package called tidycensus
library(tidycensus) #activates the tidycensus package in the working session
library(tigris) #activates the tigris package in the working session

census_api_key("06f9cb24529c462c279e7d52e18ec7798e6bfeec") #installs a unique API specific to this computer that connects to the online census data
              
#type ?census_api_key to get your Census API for full access.

age10 <- get_decennial(geography = "state", 
                       variables = "P013001", 
                       year = 2010) #creates dataframe object that pulls data from the 2010 decennial census dataset hosted online with columns for geoid, state, variable P013001=median age)

head(age10) #brings up a tibble showing the first six rows of the table 


bexar_medincome <- get_acs(geography = "tract", variables = "B19013_001",
                           state = "TX", county = "Bexar", geometry = F) #creates dataframe object that pulls data from american community survey (part of census data) for Bexar County, TX with columns geoid, tract name, variable B19013_001=median income, and margin of error


View(bexar_medincome) #opens tab displaying the dataframe object

class(bexar_medincome) #tells you what class the object is

#---- Part 2: Visualizing the data ----
#install.packages('ggplot2')

library(ggplot2) #activates package ggplot2



## ---- Part 2.1: Visualizing the 'usa_arrests' data ----

ggplot() #brings up a blank plot in the plots window

#scatter plot - relationship between two continuous variables
ggplot(data = usa_arrests,mapping = aes(x=Assault,y=Murder)) +
  geom_point() #creates a scatterplot with points representing data from usa_arrests with x axis Assault and Y axis Murder

ggplot() +
  geom_point(data = usa_arrests,mapping = aes(x=Assault,y=Murder)) #creates a plot with points representing data from usa_arrests with x axis Assault and Y axis Murder


#bar plot - compare levels across observations
usa_arrests$state<-rownames(usa_arrests) #creates a new column in dataframe called "state" to be populated from the rownames of the dataframe

ggplot(data = usa_arrests,aes(x=state,y=Murder))+
  geom_bar(stat = 'identity') #creates a bar plot of usa_arrests data where x=state and y axis shows number of murders

ggplot(data = usa_arrests,aes(x=reorder(state,Murder),y=Murder))+
  geom_bar(stat = 'identity')+
  coord_flip() #creates a bar plot of usa_arrests data that flips the x and y axis

# adding color # would murder arrests be related to the percentage of urban population in the state?
ggplot(data = usa_arrests,aes(x=reorder(state,Murder),y=Murder,fill=UrbanPop))+
  geom_bar(stat = 'identity')+
  coord_flip() #creates a bar plot of usa_arrests data that flips the x and y axis and fills in the bars with a color scale representing the values in the urban population column

# adding size
ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop)) +
  geom_point() #creates a scatter plot with x axis = assaults and y axis = murders with each dot of the scatterplot representing the values in the urban population column


# plotting by south-east and everyone else 

usa_arrests$southeast<-as.numeric(usa_arrests$state%in%c("Florida","Georgia","Mississippi","Lousiana","South Carolina")) #creates a column in the dataframe object usa_arrests called southeast and populates it with a numeric value to represent true or false (1 or 0) for the states listed - i.e., Florida, Georgia, Mississippi, Louisiana, and South Carolina are all states in the southeastern region of the US so they are given value 1 to represent true


ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop, color=southeast)) +
  geom_point() #creates a scatterplot with x axis = assaults and y axis = murders with each dot of the scatterplot representing the values in the urban population column and the color of each dot determined by the value in the southeast column

usa_arrests$southeast<-factor(usa_arrests$southeast,levels = c(1,0),labels = c("South-east state",'other')) #assigns text labels to the numeric values in the column southeast such that 1 becomes South-east state and 0 becomes other

ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop)) +
  geom_point()+
  facet_wrap(southeast~ .) #creates two scatterplots with x axis = assaults and y axis = murders with each dot of the scatterplot representing the values in the urban population column; one scatterplot shows the data for all "South-east state" values in the southeast column and the second shows the data for all "other" values; both use the same y axis but they each have their own x axis


ggplot(data = usa_arrests,aes(x=Assault,y=Murder, size=UrbanPop)) +
  geom_point()+
  facet_grid(southeast ~ .) #creates two scatterplots with x axis = assaults and y axis = murders with each dot of the scatterplot representing the values in the urban population column; one scatterplot shows the data for all "South-east state" values in the southeast column and the second shows the data for all "other" values; both use the same x axis but they each have their own y axis

## ---- Part 3: Visualizing the spatial data ----
# Administrative boundaries


library(leaflet)
library(tigris)

bexar_county <- counties(state = "TX",cb=T)
bexar_tracts<- tracts(state = "TX", county = "Bexar",cb=T)
bexar_blockgps <- block_groups(state = "TX", county = "Bexar",cb=T)
#bexar_blocks <- blocks(state = "TX", county = "Bexar") #takes lots of time


# incremental visualization (static)

ggplot()+
  geom_sf(data = bexar_county)

ggplot()+
  geom_sf(data = bexar_county[bexar_county$NAME=="Bexar",])

ggplot()+
  geom_sf(data = bexar_county[bexar_county$NAME=="Bexar",])+
  geom_sf(data = bexar_tracts)

p1<-ggplot()+
  geom_sf(data = bexar_county[bexar_county$NAME=="Bexar",],color='blue',fill=NA)+
  geom_sf(data = bexar_tracts,color='black',fill=NA)+
  geom_sf(data = bexar_blockgps,color='red',fill=NA)

ggsave(filename = "02_lab/plots/01_static_map.pdf",plot = p1) #saves the plot as a pdf



# incremental visualization (interactive)

#install.packages("mapview")
library(mapview)

mapview(bexar_county)

mapview(bexar_county[bexar_county$NAME=="Bexar",])+
  mapview(bexar_tracts)

mapview(bexar_county[bexar_county$NAME=="Bexar",])+
  mapview(bexar_tracts)+
  mapview(bexar_blockgps)


#another way to vizualize this
leaflet(bexar_county) %>%
  addTiles() %>%
  addPolygons()

names(table(bexar_county$NAME))

leaflet(bexar_county[bexar_county$NAME=="Bexar",]) %>%
  addTiles() %>%
  addPolygons()

leaflet(bexar_county[bexar_county$NAME=="Bexar",]) %>%
  addTiles() %>%
  addPolygons(group="county")%>%
  addPolygons(data=bexar_tracts,group="tracts") %>%
  addPolygons(data=bexar_blockgps,color = "#444444", weight = 1,group="block groups")

leaflet(bexar_county[bexar_county$NAME=="Bexar",]) %>%
  addTiles() %>%
  addPolygons(group="county")%>%
  addPolygons(data=bexar_tracts,group="tracts") %>%
  addPolygons(data=bexar_blockgps,color = "#444444", weight = 1,group="block groups") %>%
  addLayersControl(
    overlayGroups = c("county", "tracts","block groups"),
    options = layersControlOptions(collapsed = FALSE)
  )



