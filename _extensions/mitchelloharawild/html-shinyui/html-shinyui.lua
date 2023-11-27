local function ensure_html_deps()
  quarto.doc.add_html_dependency({
    name = "jquery",
    version = "3.6.0",
    scripts = {
      { path = "asset/jquery.min.js"}
    }
  })
  quarto.doc.add_html_dependency({
    name = "shiny",
    version = "1.8.0.9000",
    scripts = {
      { path = "resources/js/shiny.min.js" }
    },
    stylesheets = {"resources/css/shiny.min.css"}
  })
end


if quarto.doc.is_format('html:js') then
  ensure_html_deps()
end
