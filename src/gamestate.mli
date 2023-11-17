

module Player_Map = Map.Make(String)

type GameState_data = {
    countries: Country.Country Player_Map.t
    player_decks: (action_card_deck * investment_card_deck) Player_Map.t
    domestic_event_deck: domestic_event_card list;
    international_event_deck: international_event_card list;
    victory_conditions: bool Player_Map.t;
    current_turn: string
}

module type GameTurn = sig
    type t
    val play_turn: t -> string -> t (* gamestate_data -> turn_stage -> gamestate_data *)
    val check_victory: t -> string option (* gamestate_data -> optional winner name *)
    val get_turn_stage: t -> string (* Red signaling -> Blue investments / action -> Red investments / action -> ... *)

end

module type GameStateManager = sig
    include GameTurn;
    type t
    val send_gamestate_to_client: t -> unit
    val receive_gamestate_data: unit -> t
    val get_gamestate_summary: t -> string (* gamestate_data -> text summary of world *)
    val play_round: t -> t
end

module MakeGameStateManager (GameState: sig val get_state: GameState_data end) : GameStateManager
