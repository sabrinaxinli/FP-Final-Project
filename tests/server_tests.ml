open OUnit2
open Lwt
open Server

let start_echo_server (port : int) : Lwt_io.server Lwt.t =
  let addr = Lwt_unix.ADDR_INET (Caml_unix.inet_addr_loopback, port) in
  Lwt_io.establish_server_with_client_address addr DefaultServer.echo_service

let start_game_server (port : int) : Lwt_io.server Lwt.t =
  let addr = Lwt_unix.ADDR_INET (Caml_unix.inet_addr_loopback, port) in
  let callback _ (ic, oc) =
    DefaultServer.determine_role ic oc
  in  
  Lwt_io.establish_server_with_client_address addr callback

let test_echo_service echo_port _ =
  let server_thread = start_echo_server echo_port in

  let client () =
    (* Create a socket and connect to the server *)
    let sock = Lwt_unix.socket Lwt_unix.PF_INET Lwt_unix.SOCK_STREAM 0 in
    let addr = Lwt_unix.ADDR_INET (Caml_unix.inet_addr_loopback, echo_port) in
    Lwt_unix.connect sock addr >>= fun () ->

    (* Create Lwt channels for the socket *)
    let ic = Lwt_io.of_fd ~mode:Lwt_io.input sock in
    let oc = Lwt_io.of_fd ~mode:Lwt_io.output sock in

    (* Send a message to the server *)
    let message = "Hello, server!" in
    Lwt_io.write_line oc message >>= fun () ->

    (* Read the response from the server *)
    Lwt_io.read_line ic >>= fun response ->

    (* Close the socket *)
    Lwt_unix.close sock >>= fun () ->

    (* Assert that the response matches the message *)
    Lwt.return (assert_equal message response)
  in
  let test_result = Lwt_main.run (client ()) in
  Lwt.cancel server_thread;  (* Stop the server after the test *)
  test_result

let test_determine_role_facilitator game_port _ =
  let server_thread = start_game_server game_port in

  let client () =
    (* Create a socket and connect to the server *)
    let sock = Lwt_unix.socket Lwt_unix.PF_INET Lwt_unix.SOCK_STREAM 0 in
    let addr = Lwt_unix.ADDR_INET (Caml_unix.inet_addr_loopback, game_port) in
    Lwt_unix.connect sock addr >>= fun () ->

    (* Create Lwt channels for the socket *)
    let ic = Lwt_io.of_fd ~mode:Lwt_io.input sock in
    let oc = Lwt_io.of_fd ~mode:Lwt_io.output sock in

    (* Read initial message from the server *)
    Lwt_io.read_line ic >>= fun _ ->

    (* Send role to the server *)
    let message = "F" in
    Lwt_io.write_line oc message >>= fun () ->

    (* Read the response from the server *)
    Lwt_io.read_line ic >>= fun response ->

    (* Close the socket *)
    Lwt_unix.close sock >>= fun () ->

    (* Assert that the response matches the message *)
    print_endline "HERE";
    print_endline response;
    Lwt.return (assert_equal "INITIAL SETTINGS FOR F" response)
  in
  let test_result = Lwt_main.run (client ()) in
  Lwt.cancel server_thread;  (* Stop the server after the test *)
  test_result

let test_determine_role_blue game_port _ =
  let server_thread = start_game_server game_port in

  let client () =
    (* Create a socket and connect to the server *)
    let sock = Lwt_unix.socket Lwt_unix.PF_INET Lwt_unix.SOCK_STREAM 0 in
    let addr = Lwt_unix.ADDR_INET (Caml_unix.inet_addr_loopback, game_port) in
    Lwt_unix.connect sock addr >>= fun () ->

    (* Create Lwt channels for the socket *)
    let ic = Lwt_io.of_fd ~mode:Lwt_io.input sock in
    let oc = Lwt_io.of_fd ~mode:Lwt_io.output sock in

    (* Send role to the server *)
    let message = "F" in
    Lwt_io.write_line oc message >>= fun () ->

    (* Read the response from the server *)
    Lwt_io.read_line ic >>= fun response ->

    (* Close the socket *)
    Lwt_unix.close sock >>= fun () ->

    (* Assert that the response matches the message *)
    Lwt.return (assert_equal "INITIAL SETTINGS FOR B" response)
  in
  let test_result = Lwt_main.run (client ()) in
  Lwt.cancel server_thread;  (* Stop the server after the test *)
  test_result
  

(* Test suite *)
let suite echo_port game_port =
  "test_server" >::: [
    "test_echo_service" >::: [
      "test_echo_service" >:: test_echo_service echo_port;
    ];

    "test_determine_role" >::: [
      "test_determine_role_facilitator" >:: test_determine_role_facilitator game_port;
      "test_determine_role_blue" >:: test_determine_role_blue game_port;
    ]
  ]

(* Run the tests *)
let () =
  let echo_port = 3007 in
  let game_port = 3000 in
  run_test_tt_main (suite echo_port game_port)