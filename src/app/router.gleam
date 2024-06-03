import app/web
import routes/page.{home_page}
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: web.Context) -> Response {
  use _req <- web.middleware(req, ctx)
  case wisp.path_segments(req) {
    [] -> wisp.html_response(home_page(), 200)
    // ["static", file] -> 
    _ -> wisp.not_found()
  }
}
