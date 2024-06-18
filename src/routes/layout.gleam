import argv
import config.{dyn_src_path}
import gleam/bbmustache
import gleam/io
import gleam/string_builder

pub fn get_str() {
  let path = case argv.load().arguments {
    ["dev"] -> dyn_src_path() <> "/routes/layout_hr.html"
    _ -> dyn_src_path() <> "/routes/layout.html"
  }
  case bbmustache.compile_file(path) {
    Ok(template) -> {
      let rendered = bbmustache.render(template, [])
      string_builder.from_string(rendered)
    }
    Error(e) -> {
      io.debug(e)
      string_builder.from_string("")
    }
  }
}
