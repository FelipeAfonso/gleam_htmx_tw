import gleam/erlang/process
import gleam/function
import gleam/otp/actor
import gleam/string
import gleam/string_builder
import mist
import repeatedly
import wisp

pub type EventState {
  EventState(id: String, repeater: repeatedly.Repeater(Nil))
}

pub type Event {
  Id(String)
  Down(process.ProcessDown)
}

pub fn start_sse_for_hot_reload(req) {
  mist.server_sent_events(
    req,
    wisp.response(200),
    init: fn() {
      let subj = process.new_subject()
      let monitor = process.monitor_process(process.self())
      let selector =
        process.new_selector()
        |> process.selecting(subj, function.identity)
        |> process.selecting_process_down(monitor, Down)
      let repeater =
        repeatedly.call(1000, Nil, fn(_state, _count) {
          let id = wisp.random_string(64)
          process.send(subj, Id(id))
        })
      actor.Ready(EventState("", repeater), selector)
    },
    loop: fn(message, conn, state) {
      case message {
        Id(value) -> {
          let event = mist.event(string_builder.from_string(value))
          case mist.send_event(conn, event) {
            Ok(_) -> {
              wisp.log_info("Sent event: " <> string.inspect(event))
              let id = wisp.random_string(64)
              actor.continue(EventState(..state, id: id))
            }
            Error(_) -> {
              repeatedly.stop(state.repeater)
              actor.Stop(process.Normal)
            }
          }
        }
        Down(_process_down) -> {
          repeatedly.stop(state.repeater)
          actor.Stop(process.Normal)
        }
      }
    },
  )
}
