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

  This is an executable - here is example code to send a string to the server,
  and recieve an echo back, printing to the command line. 
   
  The real client will connect to the server, recieve and print the starting
  game state / scenario, and wait for the player's actions, which will then be
  transmitted.
   
*)