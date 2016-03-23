require(whisker)
require(jsonlite)


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

source("_init.R")
source("Build_Source_Code.R.R")
source("Build_DESCRIPTION.R.R")
source("Build_LICENSE.R.R")