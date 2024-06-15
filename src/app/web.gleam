import wisp

pub type Context {
  Context(static_directory: String, build_id: String)
}

pub fn middleware(
  req: wisp.Request,
  ctx: Context,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- selective_logging(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  use <- wisp.serve_static(req, under: "/static", from: ctx.static_directory)
  handle_request(req)
}

fn selective_logging(
  req: wisp.Request,
  usage: fn() -> wisp.Response,
) -> wisp.Response {
  case req.path {
    "/reload" -> usage()
    _ -> wisp.log_request(req, usage)
  }
}
