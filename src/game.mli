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

type card_type = ACTION | INVESTMENT | DOMESTIC_EVENT | INTERNATIONAL_EVENT

(* type card_type = ACTION | INVESTMENT | DOMESTIC_EVENT | INTERNATIONAL_EVENT *)

type card = {
  player: string;
  card_type: card_type;
  title: string;
  description: string;
  card_number: string;
  aor: string option;
  public: bool option;
  play_cost: int option;
  replayable: bool;
}

val card_to_yojson : card -> Yojson.Safe.t
val card_of_yojson : Yojson.Safe.t -> (card, string) result

type proposed_action =
  | PlayCards of string
  | ProcureForce of string * Country.force
  | ModernizeForce of string * Country.force
  | DeployForces of string * string * Country.force list
  | InitiateCombat of string * Country.force list
  | BuybackReadiness of string * Country.force list * int
  | Done

val proposed_action_to_yojson: proposed_action -> Yojson.Safe.t
val proposed_action_of_yojson: Yojson.Safe.t -> (proposed_action, string) result

type player_responses_map

type victory_conditions_map

type resolution_maps

type game_data = {
  countries: player_country_map;
  player_decks: player_decks;
  domestic_event_deck: card list;
  international_event_deck: card list;
  victory_conditions: victory_conditions_map;
  current_turn: string;
  resolution_tables: resolution_maps; (* map to maps*)
}

module type Deck = sig
  type t = card
  
  val load_cards: unit -> t list (* Will contain logic for data loading for cards from specified path *)
  val get_size: t list -> int
  val sorted_by: t list -> string -> t list (* string contains info to be sorted by *)
  
  (* Card mechanics *)
  val evaluate_card_result: t -> game_data -> player_responses_map -> game_data
end

module type GameState = sig
  type t
  (* Handle game loadup and config files and building the inital game_data record *)
  val start_game: countries_fp : string -> player_decks_dir : string -> domestic_fp: string -> int_fp: string -> t
  (* Play the entire signaling phase *)
  val play_signaling_phase: t -> t (* game_data -> turn_stage -> game_data *)
  (* Get a red signal from one player *)
  val get_red_signal: t -> string -> card list
  (* gamestate_data -> country_name -> game_data *)
  val play_investments_actions_phase: t -> string -> t
  (* Budget fluctuations and give round of resources to all players *)
  val update_resource_allocations: t -> t
  (* Red signaling -> Blue investments / action -> Red investments / action -> ... *)
  val get_turn_stage: t -> string
  (* Get a proposed action from a player, asking again until the proposed action is valid *)
  val get_proposed_action: t -> string -> validator : (proposed_action -> bool) -> proposed_action
  (* Validate the proposed action *)
  val validate_action: proposed_action -> bool
  (* Validate specifically the proposed action in response to a played card *)
  val validate_response: proposed_action -> bool
  (* Play a card, let all involved players respond, and evaluate card result. *)
  val play_card : t -> card -> t
end
  
module type Adjudicator = sig
  type t
  val get_combat_factor: Country.country_data -> int
  val get_combat_factor_ratio: Country.country_data -> Country.country_data -> int
  val adjudicate_combat: Country.country_data -> Country.country_data -> (int * Country.country_data * Country.country_data) (* int signifying which side won, updated Country info *)
  val adjudicate_noncombat: Country.country_data -> Country.country_data -> (Country.country_data * Country.country_data)
end

(* module MakeAdjudicator(_: sig val resolution_table_path: string end) : Adjudicator *)