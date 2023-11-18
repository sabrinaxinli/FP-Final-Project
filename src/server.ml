open Core
open Async
open Lwt

let echo_client host port =
  Lwt_io.with_connection (Lwt_unix.ADDR_INET (Unix.Inet_addr.of_string host, port))
    (fun (r, w) ->
      let line = "Hello, world!" in
      Lwt_io.write_line w line >>= fun () ->
      Lwt_io.read_line r >>= fun response ->
      print_endline response;
      return ()
    )

let () =
  let host = "localhost" and port = 7 in
  ignore (Lwt_main.run (echo_client host port))

(*

  This is an executable - here is example code to listen for a string from a
  client, then echo recieved strings back.
   
  The real server will listen for clients, transmit the starting game state /
  scenario, wait for the client to send player's actions, and update the game
  state, in coordination with the facilitator human.
   
*)