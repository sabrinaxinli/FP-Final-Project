(* module type VictoryCondition : sig
    type Player
    type IP
    val check_for_victory : (Player * IP) List -> (Player * Bool) List
end

module Create_victory_condition : VictoryCondition *)

(* open Country
open Core *)
(* 
module Player_Map = Map.Make(String) *)



type player_country_map
type player_decks


(* type card_type = ACTION | INVESTMENT | DOMESTIC_EVENT | INTERNATIONAL_EVENT *)

type card = {
    card_type: string;
    title: string;
    description: string;
    card_number: int;
    aor: string option;
    public: bool option;
    play_cost: int option;
}

module type Card = sig
    type t

    val get_card_type: t -> string
    val get_title: t -> string
    val get_description: t -> string
    val get_card_number: t -> int
    val get_aor: t -> string option
    val get_public: t -> bool option
    val get_play_cost: t -> int option
    val execute_card: t -> player_country_map -> player_country_map
end

module type Deck = sig
    type t
    val load_cards: unit -> t (* Will contain logic for data loading for cards from specified path *)
    val get_size: t -> int
    val sorted_by: t -> string -> t (* string contains info to be sorted by *)
end

module MakeDeck(_ : sig val filepath: string end) : Deck

type victory_conditions_map

type game_data = {
    countries: player_country_map;
    player_decks: player_decks;
    domestic_event_deck: card list;
    international_event_deck: card list;
    victory_conditions: victory_conditions_map;
    current_turn: string
}

module type GameTurn = sig
    type t
    val start_game: unit -> t
    val play_signaling_phase: t -> t (* game_data -> turn_stage -> game_data *)
    val play_investments_actions_phase: t -> string -> t (* gamestate_data -> country_name -> game_data *)
    val update_resource_allocations: t -> t
    val get_turn_stage: t -> string (* Red signaling -> Blue investments / action -> Red investments / action -> ... *)
end

module type Adjudicator = sig
    type t
  
    val get_combat_factor: Country.country_data -> int
    val get_combat_factor_ratio: Country.country_data -> Country.country_data -> int
    val adjudicate_combat: Country.country_data -> Country.country_data -> (int * Country.country_data * Country.country_data) (* int signifying which side won, updated Country info *)
    val adjudicate_noncombat: Country.country_data -> Country.country_data -> (Country.country_data * Country.country_data)
  end

(* module MakeAdjudicator(_: sig val resolution_table_path: string end) : Adjudicator *)