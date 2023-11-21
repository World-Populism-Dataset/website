library(purrr)
library(stringr)
rmarkdown::pandoc_convert("WPD Case Notes.docx", output = "notes.md", to = "markdown", from = "docx")

notes <- readLines("notes.md")
notes <- split(notes, cumsum(grepl("^#\\s", notes)))[-1]

countries <- map_chr(notes, ~ sub("#\\s", "", .[1]))
countries <- str_to_title(trimws(countries))

pmap(list(notes, countries), function(body, country){
  xfun::write_utf8(
    c(
      "---",
      sprintf("title: %s", country),
      "---",
      "",
      body[-1]
    ),
    file.path("country", xfun::with_ext(stringi::stri_replace_all_fixed(str_to_lower(country), c(" ", "ü"), c("-", "u"), vectorize_all = FALSE), ".qmd"))
  )
})
