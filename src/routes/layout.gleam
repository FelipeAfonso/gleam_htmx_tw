import argv
import config.{dyn_src_path}
import gleam/bbmustache.{string}
import gleam/io
import gleam/string_builder

const hr_script = "<script src=\"/static/hr.js\"></script>"

const hr_trigger = "<div hx-get=\"/reload\" hx-trigger=\"every 1s\" hx-swap=\"none\" hx-target=\"#hr\">
    <input type=\"hidden\" id=\"hr\" value=\"\" />
</div>"

pub fn get_str() {
  case bbmustache.compile_file(dyn_src_path() <> "/routes/layout.html") {
    Ok(template) -> {
      case argv.load().arguments {
        ["dev"] -> {
          let rendered =
            bbmustache.render(template, [
              #("hr_script", string(hr_script)),
              #("hr_trigger", string(hr_trigger)),
            ])
          string_builder.from_string(rendered)
        }
        _ -> {
          let rendered = bbmustache.render(template, [])
          string_builder.from_string(rendered)
        }
      }
    }
    Error(e) -> {
      io.debug(e)
      string_builder.from_string("")
    }
  }
}
