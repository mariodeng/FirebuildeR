require(whisker)
require(jsonlite)
require(devtools)

api.meta = fromJSON("http://firebrowse.org/api/api-docs/",
                    simplifyVector = F,
                    simplifyDataFrame = F,
                    simplifyMatrix = F)

api.definitions = lapply(api.meta$apis, function(current.api){
  fromJSON(paste("http://firebrowse.org/api", current.api$path, sep = ""),
           simplifyVector = F,
           simplifyDataFrame = F,
           simplifyMatrix = F)
})

Print("Building functions from API definition")
source("src/Build_Source_Code.R")
Print("Updating DESCRIPTION file")
source("src/Build_DESCRIPTION.R")
Print("Updating LICENSE file")
source("src/Build_LICENSE.R")

setwd("FirebrowseR/")
Print("Testing source code")
test()
Print("Applying unit tests")
document()
Print("done🍻")