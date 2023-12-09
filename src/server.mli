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

module DefaultServer : Server