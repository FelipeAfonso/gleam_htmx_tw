import app/router
import app/web.{Context}
import gleam/erlang/process
import gleam/io
import gleam/string
import mist
import radiate
import tailwind
import wisp

const tw_config = [
  "--config=tailwind.config.js", "--input=./src/tailwind.css",
  "--output=./priv/static/app.css",
]

pub fn main() {
  wisp.configure_logger()
  let sub = process.new_subject()
  let secret_key_base = wisp.random_string(64)
  process.send(sub, secret_key_base)
  let _ = tailwind.install()
  let _ = tailwind.run(tw_config)
  let _ =
    radiate.new()
    // if you're using macos change this to absolute
    |> radiate.add_dir("src")
    |> radiate.on_reload(fn(_state, path) {
      wisp.log_info("Change in " <> path <> ", reloading!")
      let secret_key_base = wisp.random_string(64)
      process.send(sub, secret_key_base)
      let _ = case string.ends_with(path, "html") {
        True -> {
          let _ = tailwind.run(tw_config)
          Nil
        }
        _ -> Nil
      }
    })
    |> radiate.start()

  let ctx = Context(static_directory: static_directory(), sub: sub)
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
