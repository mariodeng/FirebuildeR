template = readLines("templates/DESCRIPTION.mustache")

api.meta$apiVersion = unlist(strsplit(api.meta$apiVersion, " ", fixed = T))[1]
api.meta$today = Sys.time()
parsed.function = whisker.render(template, api.meta)
file.name = paste("FirebrowseR/DESCRIPTION")
writeLines(parsed.function, file.name)
