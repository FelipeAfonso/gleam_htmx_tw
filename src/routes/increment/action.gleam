import gleam/bbmustache.{int}
import gleam/int
import gleam/io
import gleam/list
import gleam/string_builder
import wisp.{type Request, type Response}

pub fn increment(req: Request) -> Response {
  use formdata <- wisp.require_form(req)
  io.debug(formdata)
  let count = case list.key_find(formdata.values, "count") {
    Ok(count) -> count
    Error(_) -> "0"
  }
  wisp.log_info(count)
  case int.parse(count) {
    Ok(count) -> {
      let assert Ok(template) =
        bbmustache.compile(
          "<input type=\"hidden\" name=\"count\" value=\"{{value}}\" hx-swap-oob=\"outerHTML:[name='count']\" />{{value}}",
        )
      let rendered = bbmustache.render(template, [#("value", int(count + 1))])
      wisp.html_response(string_builder.from_string(rendered), 200)
    }
    Error(_) -> {
      wisp.html_response(string_builder.from_string(""), 200)
    }
  }
}
