import app/router
import app/web.{Context}
import argv
import config.{dyn_src_path, tw_config}
import gleam/erlang/process
import gleam/io
import gleam/string
import mist
import radiate
import simplifile
import tailwind
import wisp

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
    |> mist.port(8080)
    |> mist.start_http()

  case argv.load().arguments {
    ["dev"] -> {
      io.println("Running with Hot Reload")
      let _ =
        radiate.new()
        |> radiate.add_dir(dyn_src_path())
        |> radiate.on_reload(fn(_state, path) {
          io.println("Change in " <> path <> ", reloading!")
          let unique_key = wisp.random_string(64)
          let assert Ok(_) =
            unique_key
            |> simplifile.write(to: dyn_src_path() <> "/.hrid")
          let _ = case string.ends_with(path, "html") {
            True -> {
              let _ = tailwind.run(tw_config)
              Nil
            }
            _ -> Nil
          }
        })
        |> radiate.start()
      Nil
    }
    _ -> {
      io.println("Running without Hot Reload")
      Nil
    }
  }

  process.sleep_forever()
}

pub fn static_directory() -> String {
  let assert Ok(priv_directory) = wisp.priv_directory("gleam_htmx_tw")
  priv_directory <> "/static"
}
