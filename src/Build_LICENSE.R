template = readLines("templates/LICENSE.mustache")

l = list()
l$year = substr(Sys.Date(), 1, 4)
parsed.function = whisker.render(template, l)
file.name = paste("FirebrowseR/LICENSE")
writeLines(parsed.function, file.name)
