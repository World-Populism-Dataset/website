library(purrr)
library(stringr)
rmarkdown::pandoc_convert("WPD Case Notes.docx", output = "notes.md", to = "markdown", from = "docx")

notes <- readLines("notes.md")
# Remove empty headers
notes <- gsub("^#+\\s*$", "", notes)
notes <- split(notes, cumsum(grepl("^#\\s", notes)))[-1]

countries <- map_chr(notes, ~ sub("#\\s", "", .[1]))
countries <- str_to_title(trimws(countries))

pmap(list(notes, countries), function(body, country){
  # rm country title from body
  body <- body[-1]

  # if(country == "Argentina") browser()
  # isolate country metadata for banner block
  headers <- grepl("^\\#+", body[-1])
  headers <- cumsum(headers)
  # if(!is.finite(min(headers))) browser()
  metadata <- headers == min(headers)

  # Trim lines from metadata
  metadata_idx <- range(which(nzchar(body[metadata])))
  metadata_notes <- body[seq(metadata_idx[1], metadata_idx[2])]
  metadata_notes[!nzchar(metadata_notes)] <- "<br>"
  metadata_notes <- paste0(metadata_notes, collapse = "\n")

  front_matter <- yaml::as.yaml(
    list(
      title = country,
      subtitle = metadata_notes,
      `title-block-banner` = TRUE
    )
  )

  xfun::write_utf8(
    c(
      "---",
      front_matter,
      "---",
      "",
      "# Case notes",
      body[!metadata]
    ),
    file.path("countries", xfun::with_ext(stringi::stri_replace_all_fixed(str_to_lower(country), c(" ", "ü"), c("-", "u"), vectorize_all = FALSE), ".qmd"))
  )
})
