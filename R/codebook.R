library(purrr)
library(stringr)
rmarkdown::pandoc_convert("WPD Code Book draft 23.11.2023.docx", output = "codebook.md", to = "markdown", from = "docx")

data <- xfun::read_utf8("data.qmd")
xfun::write_utf8(gsub("^(#+\\s*)\\*\\*(.*?)\\*\\*", "\\1\\2", data), "data.qmd")
