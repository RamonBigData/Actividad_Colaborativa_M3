# Actividad_Colaborativa_M3
## Ejcutar los packeges
library(knitr)
## Crear mi directorio de trabajo
getwd()
setwd("/Users/ramoncd/Documents/Actividad_colaborativa_M3")
getwd()
## Crear la carpeta de trabajo data
if (!file.exists("./data")) 
  {
  dir.create("./data")
  }
## Descarga de datos y descomprimimos el archivo zip
fileURL <- "https://data.medicare.gov/views/bg9k-emty/files/e514828f-8ed2-445f-b49f-5ac11a58869d?content_type=application%2Fzip%3B%20charset%3Dbinary&filename=Hospital_Revised_Flatfiles.zip"
download.file(fileURL,destfile="./data/Hospital_Revised_Flatfiles.zip",method="curl")
unzip("./data/Hospital_Revised_Flatfiles.zip", exdir="./data")

#Listamos el contenido del archivo descomprimido y grabamos la fecha de descarga
list.files("./data")
fechaDescarga <- date()
#Leemos nuestro archivo que vamos a limpiar
Hginfo <- read.table("./data/Hospital General Information.csv", sep=",", header=T)
Hginfo
head(Hginfo[,1:11])

##Quitamos los puntos que tienen las columnas
column_Hginfo <- gsub("\\.", "_" ,names(Hginfo))
names(Hginfo)<-column_Hginfo
head(Hginfo[,1:15])

##Pasamos todos los nombres de las columnas a minuscualas
names(Hginfo)<-tolower(names(Hginfo))
names(Hginfo)
head(Hginfo[,1:10])

##Pasamos el contenido de las filas a minusculas
data.frame(tolower(as.matrix(Hginfo[,1:10])))
Hginfo[,1:10]<-data.frame(tolower(as.matrix(Hginfo[,1:10])))
head(Hginfo[,1:10])

#Ordenamos por las columna por city
HginfoNew <- Hginfo[order(Hginfo$city), ]
kable(HginfoNew [1:10,1:10])

#Eliminos el campo not available ya que no nos propociona de información.
cleanHginfoNew<-HginfoNew
cleanHginfoNew<- cleanHginfoNew[cleanHginfoNew$hospital_overall_rating!="Not Available" & 
                                  cleanHginfoNew$mortality_national_comparison!="Not Available" &
                                  cleanHginfoNew$safety_of_care_national_comparison!="Not Available",]
cleanHginfoNew[1:10,1:16]

#Eliminamos las columnas vacias ya que no nos aporta nada de información
cleanHginfoNew<-cleanHginfoNew[ ,-16]
cleanHginfoNew <- cleanHginfoNew[ ,!colnames(cleanHginfoNew)=="mortality_national_comparison_footnote"]
cleanHginfoNew<-cleanHginfoNew[ ,-17]
cleanHginfoNew <- cleanHginfoNew[ ,!colnames(cleanHginfoNew)=="safety_of_care_national_comparison_footnote"]
cleanHginfoNew<-cleanHginfoNew[ ,-18]
cleanHginfoNew <- cleanHginfoNew[ ,!colnames(cleanHginfoNew)=="readmission_national_comparison_footnote"]
head(cleanHginfoNew[1:10,1:18])

#Crear una carpeta output para añadir nuestro tidydata
if (!file.exists("./data/output")) {
  dir.create("./data/output")
}
#Creamos nuestro nuevo archivo en foramto csv y lo leemos para ver como ha quedado.
write.csv2(cleanHginfoNew,file = "./data/output/Hospital_General_InformationModfy.csv")
cleanHginfoNewRead <- read.csv2("./data/output/Hospital_General_InformationModfy.csv")
head(cleanHginfoNewRead)[,1:18]
