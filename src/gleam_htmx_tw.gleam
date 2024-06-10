import app/router
import app/web.{Context}
import gleam/erlang/process
import mist
import tailwind
import wisp

pub fn main() {
  wisp.configure_logger()
  // let _ = tailwind.install()
  let _ =
    tailwind.run([
      "--config=tailwind.config.js", "--input=./src/tailwind.css",
      "--output=./priv/static/app.css",
    ])
  let secret_key_base = wisp.random_string(64)
  let ctx = Context(static_directory: static_directory())
  let handler = router.handle_request(_, ctx)
  let assert Ok(_) =
    wisp.mist_handler(handler, secret_key_base)
    |> mist.new
    |> mist.port(3000)
    |> mist.start_http()
  process.sleep_forever()
}

pub fn static_directory() -> String {
  let assert Ok(priv_directory) = wisp.priv_directory("gleam_htmx_tw")
  priv_directory <> "/static"
}
