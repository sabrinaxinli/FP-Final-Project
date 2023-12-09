open Core
open Server

let () =
  let argv = Sys.get_argv () in 
  let echo_port =
    if Array.length argv > 1 then int_of_string argv.(1) else 3007
  in
  let game_port =
    if Array.length argv > 2 then int_of_string argv.(2) else 3000
  in
  ignore @@ Lwt_main.run @@ DefaultServer.start_server echo_port game_port
