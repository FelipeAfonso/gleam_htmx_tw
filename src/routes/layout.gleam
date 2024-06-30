import argv
import config.{dyn_src_path}
import gleam/bbmustache
import gleam/io
import gleam/string_builder.{type StringBuilder}

const hr_script = "<script src=\"/static/hr.js\"></script>"

const hr_trigger = "<div hx-get=\"/reload\" hx-trigger=\"every 1s\" hx-swap=\"none\" hx-target=\"#hr\">
    <input type=\"hidden\" id=\"hr\" value=\"\" />
</div>"

pub fn get_str(page: StringBuilder) {
  case bbmustache.compile_file(dyn_src_path() <> "/routes/layout.html") {
    Ok(template) -> {
      let input_vars = case argv.load().arguments {
        ["dev"] -> [
          #("hr_script", bbmustache.string(hr_script)),
          #("hr_trigger", bbmustache.string(hr_trigger)),
          #("body", bbmustache.builder(page)),
        ]
        _ -> [#("body", bbmustache.builder(page))]
      }
      let rendered = bbmustache.render(template, input_vars)
      string_builder.from_string(rendered)
    }
    Error(e) -> {
      io.debug(e)
      string_builder.from_string("")
    }
  }
}
