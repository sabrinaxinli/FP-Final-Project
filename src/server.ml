open Lwt
open Lwt_io

(* Echo callback *)
let handle_client (fd, _) =
  let ic = of_fd ~mode:input fd in
  let oc = of_fd ~mode:output fd in
  let rec echo_loop () =
    Lwt.catch
      (fun () ->
         read_line ic >>= fun line ->
         Printf.printf "Received: %s\n%!" line;
         write_line oc line >>= fun () ->
         echo_loop ())
      (fun e ->
         Printf.printf "Connection error: %s\n%!" (Printexc.to_string e);
         return ())
  in
  echo_loop () >>= fun () ->
  close ic >>= fun () ->
  close oc

(* Echo server *)
let echo_server port =
  let callback conn addr =
    Lwt.async (fun () -> handle_client conn)
  in
  let server = establish_server_with_client_address
                 (Unix.ADDR_INET(Unix.inet_addr_any, port)) callback in
  Printf.printf "Echo server is running on port %d\n%!" port;
  server

(* Game server *)
let game_server port =
  let callback conn addr =
    (* TODO: Implement actual game handling *)
    Lwt.async (fun () -> handle_client conn)
  in
  let server = establish_server_with_client_address
                 (Unix.ADDR_INET(Unix.inet_addr_any, port)) callback in
  Printf.printf "Game server is running on port %d\n%!" port;
  server

(* Entry point *)
let () =
  let echo_port =
    if Array.length Sys.argv > 1 then int_of_string Sys.argv.(1) else 7
  in
  let game_port =
    if Array.length Sys.argv > 2 then int_of_string Sys.argv.(2) else 3000
  in
  Lwt_main.run (Lwt.join [echo_server echo_port; game_server game_port])
