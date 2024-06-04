import app/web
import gleam/string_builder
import routes/page.{home_page}
import wisp.{type Request, type Response}

fn test_res() {
  string_builder.from_string("<p>Bye Bob</p>")
}

pub fn handle_request(req: Request, ctx: web.Context) -> Response {
  use _req <- web.middleware(req, ctx)
  case wisp.path_segments(req) {
    [] -> home_page()
    // ["reload"] -> wisp.no_content()
    ["click"] -> wisp.html_response(test_res(), 200)
    _ -> wisp.not_found()
  }
}
