import app/web
import routes/increment/action.{increment}
import routes/page.{home_page}
import simplifile
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: web.Context) -> Response {
  use _req <- web.middleware(req, ctx)
  case wisp.path_segments(req) {
    [] -> home_page()
    ["reload"] -> {
      let assert Ok(unique_key) =
        simplifile.read(
          from: "/Users/felipeafonso/code/personal/gleam_htmx_tw/src/.hrid",
        )
      wisp.response(201) |> wisp.string_body(unique_key)
    }
    ["increment"] -> increment(req)
    _ -> wisp.not_found()
  }
}
