import argv

pub const tw_config = [
  "--config=tailwind.config.js", "--input=./src/tailwind.css",
  "--output=./priv/static/app.css",
]

pub fn dyn_src_path() {
  case argv.load().arguments {
    // use an absolute path if you're getting errors on macos, like the following
    // if you do, this will screw up for deployment, so change it to relative again
    // "/Users/felipeafonso/code/personal/gleam_htmx_tw/src"
    ["dev"] -> "src"
    _ -> "/opt/deploy/src"
  }
}
