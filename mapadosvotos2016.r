require(dplyr)
library(rgdal)
library(ggplot2)
library(maptools)
library(scales)
library(data.table)
gpclibPermit()

shape <- readOGR("/home/markun/devel/eleicoes2016/shape", "zonaseleitorais2")

votacao_raw <- fread("~/devel/eleicoes2016/raw/eleicao2016/resultado/resultado2016.csv")
bancada = c(18007,18111,18000,50075,50000,50180,50505,50010)

da_bancada <- votacao_raw %>%
  filter(numero %in% bancada) %>%
  group_by(numero) %>%
  summarise(votos=sum(votos)) 
mapeia <- function(numero_c) {
  candidato <- votacao_raw %>%
    filter(numero==numero_c) %>%
    mutate(id=as.character(zona))
  
  shape_ft <- fortify(shape, region="Name") %>%
    left_join(candidato, by=c('id'='id'))
  
  print(ggplot(data=shape_ft, aes(x=long,y=lat, group=group, fill=shape_ft$votos)) +
    geom_polygon() +
    geom_path(color='black') + 
    scale_fill_distiller(name="Votos", palette = "YlGn", breaks = pretty_breaks(n = 5), direction = 1) +
    labs(x=NULL,y=NULL,title=numero_c) +
    theme(axis.text = element_blank()) +
    coord_map())

  }

unicos = unique(votacao_raw$numero)

for (n in unicos) {
  png(paste0('/home/markun/devel/eleicoes2016/mapaseleitorais2016/',n,'.png'))
  mapeia(n)
  dev.off()
}