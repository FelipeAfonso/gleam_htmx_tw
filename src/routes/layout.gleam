import gleam/bbmustache
import gleam/string_builder

pub fn get_str() {
  case bbmustache.compile_file("./src/routes/layout.html") {
    Ok(template) -> {
      let rendered = bbmustache.render(template, [])
      string_builder.from_string(rendered)
    }
    Error(_) -> {
      string_builder.from_string("")
    }
  }
}
