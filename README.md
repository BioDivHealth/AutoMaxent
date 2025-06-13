# AutoMaxent

Rather than a formal package, **AutoMaxent** is a collection of functions that facilitate the general processing and generation of data for Species Distribution Modelling type analysis. Functions can be directly downloaded from this repository or loaded and stored in **R** using the following code:

```{r}
# 0. Load/install the needed packages
  list.of.packages<-c("httr","tidyverse")
  
  new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
  if(length(new.packages)) install.packages(new.packages)
  
  lapply(list.of.packages,require,character.only=TRUE)
  rm(list.of.packages,new.packages)

# 1. Connect to the AutoMaxent GitHub repository
  git_hub <- "https://api.github.com/repos/BioDivHealth/AutoMaxent/git/trees/main?recursive=1"
  MaxRepo <- GET(git_hub) # Extract the repo information
  MaxRepo

# 2. Get the route to the functions
  file_path <- data.frame(unlist(lapply(content(MaxRepo)$tree, function(x) x$path)))
  colnames(file_path) = c('Path')
  head(file_path)

# Extract routes
  file_path <- file_path %>%
    separate(Path,c('folder','filename'),'/') %>%
    filter(folder == 'Functions') %>%
    filter(str_detect(filename,'.R'))

# 3. Configure the routes, download, and export scripts
  raw_route <- "https://raw.githubusercontent.com/BioDivHealth/AutoMaxent/main" #This is the raw route to the gitHub repository
  MyRoute <- paste(getwd(),"AutoMaxent",sep="/")
  
  for(i in 1:nrow(file_path)){
    write_lines(content(GET(paste(raw_route,file_path$folder[i],file_path$filename[i],sep="/"))),
                paste(MyRoute,file_path$filename[i],sep="/"))
  }

# 4. Load the functions
  functions <- MyRoute %>% list.files(recursive = FALSE,pattern = ".R$",full.names = TRUE)
  lapply(functions,function(x) source(x))
```

**AutoMaxent** and its complementary functions use a combination of custom and specific packages and functions to run the analysis and data preparation. Due to this, it is important to install the right version of the packages. The list of needed packages, along with their version, can be found in the same GitHub repository. This list of functions and packages is likely to change in the future with further updates to the code.


```{r}
# 1. Configure the environment to run the AutoMaxent function ----
  install.packages("remotes") ; install.packages("fs")
  library("remotes")
  library("fs")

# a Get the route to the SessionInfo folder
  file_route <- data.frame(unlist(lapply(content(MaxRepo)$tree, function(x) x$path)))
  MySession <- paste("./SessionInfo") ; MySession %>% dir.create()

# b Download and export the information    
  writeBin(content(GET(paste(raw_route,"Session_info/SessionInfo.rds",sep="/")),"raw"), paste(MySession,"SessionInfo.rds",sep="/"))

# c Load the information and install the needed packages
  Sinfo <- readRDS(MySession %>% list.files(".rds$",full.names = T))

# Older package versions can conflict with newer or older versions. Therefore, we are going to set up a new package library to host the
  new.lib <- "./SessionInfo/LibMaxEnt" ; new.lib %>% dir.create(showWarnings = FALSE,recursive = TRUE)  
  
  path_home_r(new.lib) # Set up the direction to the new library as the default (first load all the other packages)
  
# d Install the packages
  Packages <- Sinfo$otherPkgs
  Pack.nmes <- Sinfo$otherPkgs %>% names()

  # Check if packages are already installed
  new.packages <- Pack.nmes[!(Pack.nmes %in% installed.packages(lib.loc = new.lib)[,"Package"])]
  if(length(new.packages)>0){
      lapply(Packages[names(Packages) %in% new.packages], function(x) install_version(package = x$Package, version = x$Version, upgrade = "never", lib = new.lib))
  
    }else{
      print("AutoMaxent dependencies already installed!")  
    }
 
  ```

   Some libraries related to the `tydiverse` like `ggplot2` might fail to install since the code loads them before the installation. However, this should not interfere with the rest of the functions or code. Once the new library is configured, we can load the right package versions in the working environment before running the `Auto_maxent` function. 

```{r}
# a. Load the packages
path_home_r(new.lib) # MaxEnt library
lapply(installed.packages()[,"Package"],require,lib.loc=new.lib,character.only=TRUE) # Load the packages

```
 
