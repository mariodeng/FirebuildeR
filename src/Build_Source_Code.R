template = readLines("templates/Functions.mustache")

for(data in api.definitions){
  base.path = data$basePath
  resource.path = data$resourcePath
  for(api in data$apis){
    for(operation in api$operations){
      operation$function_name = substr(gsub("/", ".", api$path), 2,
                                      nchar(gsub("/", ".", api$path)))
      if(grepl("{", operation$function_name, fixed = T)){
        operation$function_name = gsub("\\{.*\\}", "", operation$function_name)
        operation$function_name = substr(operation$function_name,
                                        1,
                                        nchar(operation$function_name)-1)
        operation$mass = TRUE
      }
      operation$notes = gsub("\n", " ", operation$notes, fixed = T)
      operation$invoker = gsub("/", "", resource.path)
      operation$metod_identifier = unlist(strsplit(api$path, "/", fixed = T))
      operation$metod_identifier = setdiff(operation$metod_identifier,
                                           operation$invoker)
      operation$metod_identifier = setdiff(operation$metod_identifier, "")
      operation$has_page = lapply(operation$parameters,
                                  function(x) x$name == "page")
      operation$has_page =  any(unlist(operation$has_page))
      if("mass" %in% names(operation)){
        operation$metod_identifier = operation$metod_identifier[
          !grepl("\\{", operation$metod_identifier)]
      }
      operation$metod_identifier = paste(operation$metod_identifier, collapse = "/")
      operation$parameters[[length(operation$parameters)]]$is_last = T
      last_opt = -1
      for(i in 1:length(operation$parameters)){
        if(operation$parameters[[i]]$optionality ==  "partial"){
          operation$parameters[[i]]$optionality = T
          last_opt = i
        }else {
          operation$parameters[[i]]$optionality = F
        }
      }
      if(last_opt > 0){
        operation$parameters[[last_opt]]$last_opt = T
        operation$to_val = T
      } else {
        operation$to_val = F
      }
      parsed.function = whisker.render(template, operation)
      file.name = paste("FirebrowseR/R/", operation$function_name, ".R", sep = "")
      writeLines(parsed.function, file.name)
    }
  }
}
