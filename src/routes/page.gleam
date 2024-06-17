import config.{dyn_src_path}
import gleam/bbmustache.{string}
import gleam/io
import gleam/string_builder
import routes/layout
import wisp

pub fn home_page() {
  case bbmustache.compile_file(dyn_src_path() <> "/routes/page.html") {
    Ok(template) -> {
      let rendered = bbmustache.render(template, [#("name", string("Bob"))])
      let l = layout.get_str()
      let stringified = string_builder.from_string(rendered)
      let final = string_builder.concat([l, stringified])
      wisp.html_response(final, 200)
    }
    Error(e) -> {
      io.println("error rendering page")
      io.debug(e)
      wisp.internal_server_error()
    }
  }
}
