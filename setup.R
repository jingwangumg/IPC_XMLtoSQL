if(!exists("firsttime"))firsttime<-F

#bootstrap required libraries for autopilot 
loadlibrary<- function(package,firsttime=F,dep=T) { 
if(firsttime){ #Just install
  install.packages(package, dep = dep, repos="http://cran.us.r-project.org") 
} else {
#installs library if not pre-installed
  if (!require(package, character.only = TRUE)) {
    install.packages(package, dep = dep, repos="http://cran.us.r-project.org") 
    require(package, character.only = TRUE)
  } 
}
}

#utility library not to be loaded just installed - always accessed using namespace
if(firsttime){ #Just install
  install.packages("config", dep = TRUE, repos="http://cran.us.r-project.org") 

}

#directly accessed libraries by tsfunctions 
loadlibrary("xml2",firsttime)
loadlibrary("XML",firsttime)
install.packages("igraph")

rm(firsttime)