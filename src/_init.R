require(whisker)
require(jsonlite)
require(devtools)

api.meta = fromJSON("http://firebrowse.org/api/api-docs/",
                    simplifyVector = F,
                    simplifyDataFrame = F,
                    simplifyMatrix = F)

api.meta$apiVersion = unlist(strsplit(api.meta$apiVersion, " ", fixed = T))[1]
current.version = readLines("FirebrowseR/DESCRIPTION")
current.version = current.version[grepl("*[Vv]ersion*", current.version)]
current.version = gsub("[[:alpha:]]|[[:blank:]]|:", "", current.version)
if(current.version == api.meta$apiVersion){
  stop("Nothing to update.")
}

api.definitions = lapply(api.meta$apis, function(current.api){
  fromJSON(paste("http://firebrowse.org/api", current.api$path, sep = ""),
           simplifyVector = F,
           simplifyDataFrame = F,
           simplifyMatrix = F)
})

print("Building functions from API definition")
source("src/Build_Source_Code.R")
print("Updating DESCRIPTION file")
source("src/Build_DESCRIPTION.R")
print("Updating LICENSE file")
source("src/Build_LICENSE.R")

setwd("FirebrowseR/")
print("Unit testing")
test()
print("Building documentation")
document()
print("done")
