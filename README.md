# AutoMaxent

Rather than a formal package, **AutoMaxent** is a collection of functions that facilitate the general processing and generation of data for Species Distribution Modelling type analysis. Functions can be directly downloaded from this repository or loaded and stored in **R** using the following code:

```{r}
# 0. Load/install the needed packages
  list.of.packages<-c("httr")
  
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
    write_lines(content(GET(paste(raw_route,file_path$folder[i],file_path$filename[I],sep="/"))),
                paste(MyRoute,file_path$filename[i],sep="/"))
  }

# 4. Load the functions
  functions <- MyRoute %>% list.files(recursive = FALSE,pattern = ".R$",full.names = TRUE)
  lapply(functions,function(x) source(x))
```
