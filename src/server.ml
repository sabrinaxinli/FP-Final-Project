open Core
open Lwt

(* [@@@warning "-26"] *)
[@@@warning "-27"]
(* [@@@warning "-32"] *)

module type Server = sig
  type t
  val echo_service : Core_unix.sockaddr -> Lwt_io.input_channel * Lwt_io.output_channel -> unit Lwt.t
  val facilitator : Lwt_io.input_channel -> Lwt_io.output_channel -> unit Lwt.t
  val blue_player : Lwt_io.input_channel -> Lwt_io.output_channel -> unit Lwt.t
  val determine_role : Lwt_io.input_channel -> Lwt_io.output_channel -> unit Lwt.t
  val game_service : Core_unix.sockaddr -> Lwt_io.input_channel * Lwt_io.output_channel -> unit Lwt.t
  val create_echo_server : int -> Lwt_io.server Lwt.t
  val create_game_server : int -> Lwt_io.server Lwt.t
  val start_server : int -> int -> 'a Lwt.t
end

module DefaultServer : Server = struct
  type t

  let echo_service (_ : Core_unix.sockaddr) (channels : Lwt_io.input_channel * Lwt_io.output_channel) : unit Lwt.t =
    let ic, oc = channels in
    let rec echo_loop () =
      Lwt_io.read_line ic >>= fun line ->
      print_endline @@ sprintf "Received: %s" line;
      Lwt_io.write_line oc line >>= echo_loop
    in
    Lwt.catch
      (fun () -> echo_loop ())
      (fun (e : exn) -> print_endline @@ sprintf "Connection error: %s\n" @@ Exn.to_string e; return ()) 

  let facilitator (ic : Lwt_io.input_channel) (oc : Lwt_io.output_channel) : unit Lwt.t =
    (* get initial settings *)
    Lwt_io.write_line oc "INITIAL SETTINGS FOR F" >>=

    (* send facilitator deck *)

    (* enter facilitator handling loop *)
    return

  let blue_player (ic : Lwt_io.input_channel) (oc : Lwt_io.output_channel) : unit Lwt.t =
    (* get initial settings *)
    Lwt_io.write_line oc "INITIAL SETTINGS FOR B" >>=

    (* send player deck *)

    (* enter player handling loop *)
    return

  (* TODO: make this block and return a variant type - if we are quiting, then the server should shutdown, not pend on Ctrl-C *)
  let rec determine_role (ic : Lwt_io.input_channel) (oc : Lwt_io.output_channel) : unit Lwt.t = 
    let line = "Select a role: (F)acilitator, (B)lue player, (R)ed player, or (Q)uit: " in 
    Lwt_io.write_line oc line >>= fun () -> 
    Lwt_io.read_line ic >>= fun resp -> 
    match resp with 
    | "F" -> print_endline "Facilitator"; facilitator ic oc;
    | "B" -> print_endline "Blue Player"; blue_player ic oc;
    | "R" -> print_endline "Red Player"; return ()
    | "Q" -> print_endline "Quitting"; return ()
    | _ -> determine_role ic oc

  let game_service (_ : Core_unix.sockaddr) (channels : Lwt_io.input_channel * Lwt_io.output_channel) : unit Lwt.t =
    let ic, oc = channels in
    determine_role ic oc

  let create_echo_server (port : int) : Lwt_io.server Lwt.t =
    let addr = Lwt_unix.ADDR_INET (Caml_unix.inet_addr_loopback, port) in
    Lwt_io.establish_server_with_client_address addr echo_service

  let create_game_server (port : int) : Lwt_io.server Lwt.t =
    let addr = Lwt_unix.ADDR_INET (Caml_unix.inet_addr_loopback, port) in
    Lwt_io.establish_server_with_client_address addr game_service

  let start_server (echo_port : int) (game_port : int) : 'a Lwt.t = begin
    print_endline @@ sprintf "Starting echo server on port %d" echo_port;
    let _ = create_echo_server echo_port in

    print_endline @@ sprintf "Starting game server on port %d" game_port;
    let _ = create_game_server game_port in

    (* Create a promise that never resolves *)
    let (waiter, _) = Lwt.wait () in

    (* Return this promise to keep the loop running *)
    waiter
  end

end
