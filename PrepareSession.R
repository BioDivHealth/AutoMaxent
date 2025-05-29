rm(list=ls())
gc()

setwd(dirname(rstudioapi::getSourceEditorContext()$path)) # Set the working directory to the directory in which the code is stored
td<-tempdir()
dir.create(td,showWarnings = FALSE)

# o___/-----\___0-\/\_0/_------------o\_---___---oooo__
#     ____0__/
#___o/      \/\_0_  Set up working environment for the AutoMaxent function  /------o------o
#_____0/---
#---------__-o.oo-o-o-o-o-o--w-----o_o----o__-/\____-\|/-
#
# 0. Parameters and packages----
# Load the usual packages
  Sinfo <- readRDS("./Session_info/Sessioninfo.rds")
  install.packages("remotes") ; library("remotes")
  
  Packages <- Sinfo$otherPkgs
  lapply(Packages, function(x) install_version(package = x$Package, version = x$Version, upgrade = "never"))

# 0.a Load the packages needed ----
  lapply(Packages,function(x) require(x$Package, character.only=TRUE))
  rm(list.of.packages,new.packages)

#
#  
# End of the script
#  