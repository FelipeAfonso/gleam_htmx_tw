import gleam/bbmustache.{string}
import gleam/string_builder

pub fn home_page() {
  let template = case bbmustache.compile_file("./src/routes/page.html") {
    Ok(template) -> template
    Error(_) -> {
      let assert Ok(template) = bbmustache.compile("I failed you {{name}}")
      template
    }
  }
  let rendered = bbmustache.render(template, [#("name", string("Bob"))])
  string_builder.from_string(rendered)
}
