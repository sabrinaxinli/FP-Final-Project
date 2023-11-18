(* module type VictoryCondition : sig
    type Player
    type IP
    val check_for_victory : (Player * IP) List -> (Player * Bool) List
end

module Create_victory_condition : VictoryCondition *)

open Country

type card_type = ACTION | INVESTMENT | DOMESTIC_EVENT | INTERNATIONAL_EVENT

type card = {
	card_type: card_type;
	title: string;
	description: string;
	card_number: int;
	aor: Country.aor option;
	public: bool option;
	play_cost: int option;
}

module type Card = sig
	type t

	val get_card_type: t -> card_type
	val get_title: t -> string
	val get_description: t -> string
	val get_card_number: t -> int
	val get_aor: t -> Country.aor option
	val get_public: t -> bool option
	val get_play_cost: t -> int option
	val execute_card: t -> Country.Country -> Country.Country -> (Country.Country * Country.Country)
end

module type Deck = sig
	type t = Card list

	val load_cards: string -> t (* Will contain logic for data loading for cards from specified path *)
	val get_size: t -> int
	val sorted_by: t -> string -> t (* string contains info to be sorted by *)
end

module MakeDeck(LoadData: sig val get_filepath: string end) : Deck

module Player_Map = Map.Make(String)

type Game_data = {
    countries: Country.Country Player_Map.t
    player_decks: (action_card_deck * investment_card_deck) Player_Map.t
    domestic_event_deck: (domestic_event_card list) Player_Map.t;
    international_event_deck: international_event_card list;
    victory_conditions: bool Player_Map.t;
    current_turn: string
}

module type GameTurn = sig
    type t

    val play_signaling_phase: t -> t (* game_data -> turn_stage -> game_data *)
    val play_investments_actions_phase: t -> string -> t (* gamestate_data -> country_name -> game_data *)\
    val update_resource_allocations: t -> t
    val get_turn_stage: t -> string (* Red signaling -> Blue investments / action -> Red investments / action -> ... *)
end

module type Adjudicator = sig
	type t

	val get_combat_factor: Country.country -> int
	val get_combat_factor_ratio: County.country -> Country.country -> int
	val adjudicate_combat: Country.country -> Country.country -> (int * Country.Country * Country.Country) (* int signifying which side won, updated Country info *)
	val adjudicate_noncombat: Country.country -> Country.country -> (Country.Country * Country.Country)
end

module MakeAdjudicator(LoadData: sig val get_resolution_table_path: string end) : Adjudicator

