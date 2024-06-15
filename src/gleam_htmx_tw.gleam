import app/router
import app/web.{Context}
import gleam/erlang/process
import gleam/io
import gleam/string
import mist
import radiate
import simplifile
import tailwind
import wisp

const tw_config = [
  "--config=tailwind.config.js", "--input=./src/tailwind.css",
  "--output=./priv/static/app.css",
]

pub fn main() {
  wisp.configure_logger()
  let _ = tailwind.install()
  let _ = tailwind.run(tw_config)
  let secret_key_base = wisp.random_string(64)
  let ctx =
    Context(static_directory: static_directory(), build_id: secret_key_base)
  let handler = router.handle_request(_, ctx)
  let assert Ok(_) =
    wisp.mist_handler(handler, secret_key_base)
    |> mist.new
    |> mist.port(3000)
    |> mist.start_http()

  let _ =
    radiate.new()
    |> radiate.add_dir("/Users/felipeafonso/code/personal/gleam_htmx_tw/src")
    |> radiate.on_reload(fn(_state, path) {
      io.println("Change in " <> path <> ", reloading!")
      let unique_key = wisp.random_string(64)
      let assert Ok(_) =
        unique_key
        |> simplifile.write(
          to: "/Users/felipeafonso/code/personal/gleam_htmx_tw/src/.hrid",
        )
      let _ = case string.ends_with(path, "html") {
        True -> {
          let _ = tailwind.run(tw_config)
          Nil
        }
        _ -> Nil
      }
    })
    |> radiate.start()

  process.sleep_forever()
}

pub fn static_directory() -> String {
  let assert Ok(priv_directory) = wisp.priv_directory("gleam_htmx_tw")
  priv_directory <> "/static"
}
