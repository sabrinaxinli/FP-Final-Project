

module type GameStateManager = sig
    include Game.GameTurn;
    type gamestate
    type transfer
    val send_gamestate_to_client: transfer -> unit
    val receive_gamestate_data: unit -> transfer
    val get_gamestate_summary: gamestate -> string (* game_data -> text summary of world *)
    val get_public_display: gamestate -> string (* game_data -> text summary of public information *)
    val get_private_display: gamestate -> string -> string (* game_data -> country_name -> text summary of game_data *)
    val play_round: gamestate -> gamestate
end

module MakeGameStateManager (GameState: sig val get_init_filepaths: string list end) : GameStateManager
