import app/web
import argv
import config.{src_path}
import gleam/string
import routes/increment/action.{increment}
import routes/page.{home_page}
import simplifile
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: web.Context) -> Response {
  use _req <- web.middleware(req, ctx)
  case wisp.path_segments(req) {
    [] -> home_page()
    ["reload"] -> {
      case argv.load().arguments {
        ["dev"] -> {
          let unique_key = case simplifile.read(from: src_path <> "/.hrid") {
            Ok(key) -> key
            Error(e) -> {
              wisp.log_error(string.inspect(e))
              ""
            }
          }
          wisp.response(201) |> wisp.string_body(unique_key)
        }
        _ -> wisp.not_found()
      }
    }
    ["increment"] -> increment(req)
    _ -> wisp.not_found()
  }
}
