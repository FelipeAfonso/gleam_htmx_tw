import gleam/io
import libsql

pub fn init_db() {
  let client = libsql.create_client(libsql.Config(True, "", ""))
  client
}

pub fn execute_query() {
  let client = init_db()
  case libsql.execute("SELECT * FROM users", [], client) {
    Ok(d) -> io.print(d)
  }
}
