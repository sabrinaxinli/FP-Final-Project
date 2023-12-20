

(* Card functionality *)

type card_type = ACTION | INVESTMENT | DOMESTIC_EVENT | INTERNATIONAL_EVENT

type card = {
  player: string;
  card_type: card_type;
  title: string;
  description: string;
  card_number: string;
  involved: string list;
  aor: string option;
  public: bool option;
  play_cost: int option;
  replayable: bool;
}

val card_to_yojson : card -> Yojson.Safe.t
val card_of_yojson : Yojson.Safe.t -> (card, string) result
val equal_card: card -> card -> bool

(* Player response functionality *)

type proposed_action =
  | PlayCards of string
  | ProcureForce of string * Country.force
  | ModernizeForce of string * Country.force * int
  | DeployForces of string * string * Country.force list
  | InitiateCombat of string * string * Country.force list
  | BuybackReadiness of string * Country.force list * int
  | Done

val proposed_action_to_yojson: proposed_action -> Yojson.Safe.t
val proposed_action_of_yojson: Yojson.Safe.t -> (proposed_action, string) result

type player_responses_map

(* Gamestate data *)
module StringMap : Core.Map.S with type Key.t = string

type player_country_map = Country.country_data StringMap.t
type player_decks
type victory_conditions_map

type game_data = {
  countries: player_country_map;
  player_decks: player_decks;
  domestic_event_deck: card list;
  international_event_deck: card list;
  victory_conditions: victory_conditions_map;
  current_turn: string;
  resolution_tables: Resolution.resolution_table;
}

val get_current_countries : player_country_map -> string list

(* Deck functionality *)

type card_function (* function that takes the gamestate and does something based on card *)
type card_mapping (* type representing mapping from card_num to function *)

module type Deck = sig
	type t = card
	type m = card_mapping
  
	(* Load cards into list based on filepath *)
	val load_cards: string -> t list
	(* Get size of deck *)
	val get_size: t list -> int
	(* Dataview of card list sorted by string *)
	val sorted_by: t list -> string -> t list
	(* Get initial mapping of card_nums to card functions *)
	val build_card_mappings: unit -> m
	(* Get card function based on card_mapping and key card_num *)
	val get_card_function: m -> string -> card_function
	(* Evaluate strictly the result of the card after all players have responded and the gamestate has been updated to reflect responses *)
	val evaluate_card_result: t -> game_data -> player_responses_map -> game_data
  end

(* GameState Functionality *)
module type GameState = sig
  type t = game_data
  (* Handle game loadup and config files and building the inital game_data record *)
  val start_game: countries_fp : string -> player_decks_dir : string -> domestic_fp: string -> int_fp: string -> t
  (* Budget fluctuations and give round of resources to all players *)
  val update_resource_allocations: t -> t
  (* Get a proposed action from a player, asking again until the proposed action is valid *)
  val get_proposed_action: t -> string -> validator : (t -> string -> proposed_action -> int option) -> proposed_action * int
  (* Validate the proposed action *)
  val validate_action: t -> string -> proposed_action -> int option
  (* Validate specifically the proposed action in response to a played card *)
  val validate_response: t -> string -> proposed_action -> int option
  (* Based on gamestate, player name, and the proposed action of this player, and the previously computed cost of the action, enact this action and
	 get new gamestate *)
  val enact_action: t -> string -> proposed_action -> int -> t
  (* Begins card playing process : broadcast card description to players -> let all involved players play a number of responses
	 -> call Deck.evaluate_card_result*)
  	(* val play_card : t -> card -> t *)


  (* Game turn sequencing logic - NOT YET IMPLEMENTED *)
	(* val play_signaling_phase: t -> string -> t
	val get_red_signal: t -> string -> card list
	val play_investments_actions_phase: t -> string -> t
	val get_turn_stage: t -> string *)


end

module DeckImpl : Deck

module GameStateImpl : GameState