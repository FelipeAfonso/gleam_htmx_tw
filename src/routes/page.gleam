import gleam/bbmustache.{string}
import gleam/string_builder
import routes/layout
import wisp

pub fn home_page() {
  case bbmustache.compile_file("./src/routes/page.html") {
    Ok(template) -> {
      let rendered = bbmustache.render(template, [#("name", string("John"))])
      let l = layout.get_str()
      let stringified = string_builder.from_string(rendered)
      let final = string_builder.concat([l, stringified])
      wisp.html_response(final, 200)
    }
    Error(_) -> {
      wisp.internal_server_error()
    }
  }
}
