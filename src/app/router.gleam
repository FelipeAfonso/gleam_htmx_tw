import app/web
import gleam/erlang/process
import gleam/io
import routes/increment/action.{increment}
import routes/page.{home_page}
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: web.Context) -> Response {
  use _req <- web.middleware(req, ctx)
  case wisp.path_segments(req) {
    [] -> home_page()
    ["reload"] -> {
      let res = case process.receive(ctx.sub, 500) {
        Ok(r) -> r
        Error(msg) -> {
          io.debug(msg)
          "Failed to receive socket msg"
        }
      }
      wisp.log_info(res)
      wisp.response(201) |> wisp.string_body(res)
    }
    ["increment"] -> increment(req)
    _ -> wisp.not_found()
  }
}
