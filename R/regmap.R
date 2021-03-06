#' @title Maps visualization
#'
#' @description Plot any territory given Geojson file containing coordinates.
#' @name mapregions
#' @docType data
#' @usage map(geofile, territory, measure, ...)
#' @param geofile geoJson file to read.
#' @param territory vector of characters/factor; territories field (usualy countries, cities, etc) to choose.
#' @param measure numeric (usually); in the moste cases a quantitative variable to be setted up as measure (for example: location area, etc)
#' @param label string; the name of measure field.
#' @param main string; the title of map.
#' @param mapcol color of specific regions.
#' @param xlimit numeric; x-axis limits.
#' @param ylimit numeric; y-axis limits.
#' @return plot
#' @export
NULL
library(qdap)
library(rgdal)
regnames<-function(dataset,datacol,file,filecol){
  dataset[which(!toupper(dataset[,datacol])%in%file@data[,filecol]),]
}
#notmatch=as.character(regnames(dataset=exemp,datacol=1,file=file1,filecol=1)[,1])

subst<-function(string,replace,dataset,datacol){
  mgsub(string,replace, dataset[,datacol])
}
#distr=subst(string=notmatch,replace=c("CASTELO BRANCO","VIANA DO CASTELO"),dataset=exemp,datacol=1)

matchs<-function(dataset,datacol,file,filecol){
  dataset[match(file@data[,filecol],toupper(distr)),datacol]
}
#file1@data[,2]=matchs(exemp,2,file1,1)
regmap<-function(
  geofile,
  territory,
  labels,
  measure,
  main,
  fill,
  mapcol,
  xlimit,
  ylimit
){
  sp.label <- function(geofile, label) {
    list("sp.text", coordinates(geofile), cex=0.5,label)
  }
  numb.sp.label <- function(geofile) {
    sp.label(geofile,list(
      abrev=paste(substr(territory,1,3), labels, sep="-"),
      full=territory,
      none=rep("",length(territory))
      )
    )
  }
  make.numb.sp.label <- function(geofile,fill) {
    do.call("list", c(numb.sp.label(geofile)[1:3],list(numb.sp.label(geofile)[[4]][[fill]])))
  }
  spplot(
    geofile,
    zcol=measure,
    main=main,
    col.regions =colorRampPalette(mapcol)(length(territory)+16),
    sp.layout = make.numb.sp.label(geofile,fill),
    scales=list(draw=T),
    col="grey",
    edge.col="grey",
    colorkey=TRUE,
    xlim = apply(coordinates(geofile),2,range)[,1]+xlimit,
    ylim = apply(coordinates(geofile),2,range)[,2]+ylimit
  )
}
