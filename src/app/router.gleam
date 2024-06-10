import app/web
import routes/increment/action.{increment}
import routes/page.{home_page}
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: web.Context) -> Response {
  use _req <- web.middleware(req, ctx)
  case wisp.path_segments(req) {
    [] -> home_page()
    ["reload"] -> wisp.no_content()
    ["increment"] -> increment(req)
    _ -> wisp.not_found()
  }
}
