(* module type VictoryCondition : sig
    type Player
    type IP
    val check_for_victory : (Player * IP) List -> (Player * Bool) List
end

module Create_victory_condition : VictoryCondition *)

open Core

type card_type = ACTION | INVESTMENT | DOMESTIC_EVENT | INTERNATIONAL_EVENT [@@deriving yojson]


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
} [@@deriving yojson]

let equal_card (c1: card) (c2: card) =
  String.equal c1.card_number c2.card_number

module StringMap = Map.Make(String)


type player_country_map = Country.country_data StringMap.t

type proposed_action =
  | PlayCards of string
  | ProcureForce of string * Country.force
  | ModernizeForce of string * Country.force
  | DeployForces of string * string * Country.force list
  | InitiateCombat of string * Country.force list
  | BuybackReadiness of string * Country.force list * int
  | Done
[@@deriving yojson]

type player_responses_map = (proposed_action list) StringMap.t


type player_decks = (card list) StringMap.t

type victory_conditions_map = bool StringMap.t

type game_data = {
  countries: player_country_map;
  player_decks: player_decks;
  domestic_event_deck: card list;
  international_event_deck: card list;
  victory_conditions: victory_conditions_map;
  current_turn: string;
  resolution_tables: Resolution.resolution_table;
}

type card_function = card -> game_data -> player_responses_map -> game_data

type card_mapping = card_function StringMap.t

module type Deck = sig
  type t = card
  type m = card_mapping

  val load_cards: string -> t list (* Will contain logic for data loading for cards from specified path *)
  val get_size: t list -> int
  val sorted_by: t list -> string -> t list (* string contains info to be sorted by *)
  val build_card_mappings: unit -> m
  val get_card_function: m -> string -> (card -> game_data -> player_responses_map -> game_data)

  (* Card mechanics *)
  val evaluate_card_result: t -> game_data -> player_responses_map -> game_data
end

module Deck : Deck = struct
  type t = card
  type m = card_mapping

  let deserialize_card_list (lst : Yojson.Safe.t list) : t list =
    List.map ~f:(fun ele -> 
                  match card_of_yojson ele with
                    | Ok data -> data
                    | Error _ -> failwith "Error with element") lst

  let load_cards (filepath: string) : t list =
    match Yojson.Safe.from_file filepath with
      | `List lst -> deserialize_card_list lst
      | _ -> failwith "Did not find json list"

  let get_size (card_list: t list) : int =
    List.length card_list

  (* Implement later *)
  let sorted_by (card_list: t list) (_: string) : t list =
    card_list

  let empty_action (prm: player_responses_map) (player_name : string) : bool =
    List.length (Map.find_exn prm player_name) = 1

  let build_card_mappings () : m =
    StringMap.empty
    |> Map.add_exn ~key:"PRC-01" ~data:(fun c gd prm ->
      let modifier = if (empty_action prm "US") then red_advantage else none in
      (* Use RT B *))

  let get_card_function (map : m) (card_num: string) : (card -> game_data -> player_responses_map -> game_data) =
    Map.find_exn map card_num

  (* This is purely for evaluating the result of the card. The players should be given the card info in the Gamestate module and
     allowed to respond first before this function is called. *)
  let evaluate_card_result (_ : t) (curr_state: game_data) (map : player_responses_map): game_data =
    curr_state
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
	val get_proposed_action: t -> string -> validator : (t -> string -> proposed_action -> bool) -> proposed_action
	(* Validate the proposed action *)
	val validate_action: t -> string -> proposed_action -> bool
	(* Validate specifically the proposed action in response to a played card *)
	val validate_response: t -> string -> proposed_action -> bool
	(* Play a card, let all involved players respond, and evaluate card result. *)
	val play_card : t -> card -> t
end

module GameState = struct
  type t = game_data

  let start_game ~(countries_fp: string) ~(player_decks_dir : string) ~(domestic_fp : string) ~(int_fp : string) : t =
    let countries = PlayerCountryMap.empty in
    let country_datas = Country.CountryImpl.create countries_fp in
    let resolutions = Resolution.ActionCostImpl.get_table_map in
    let player_decks = PlayerCountryMap.empty in
    let domestic_event_deck = PlayerCountryMap.empty in
    let international_event_deck = PlayerCountryMap.empty in
    let victory_conditions = PlayerCountryMap.empty in
    let current_turn = "Red Signalling" in
    try
      let deck_dirs = Core.Sys_unix.readdir
    with
    {countries = countries;
    player_decks = player_decks;
    domestic_event_deck = Deck.load_cards domestic_fp;
    international_event_deck = Deck.load_cards int_fp;
    victory_conditions = victory_conditions;
    current_turn = "Red Signalling";
    resolution_tables = resolutions}
    

  let rec get_proposed_action (curr_state: t) (player_name: string) ~(validator: proposed_action -> bool): proposed_action =
    (* Instead of hard-coding the response from a player like below; add a server call *)
    (* I haven't yet written a serializer/deserializer for the player_country_map yet, but you can use the proposed_action
       serialize / deserializers to help *)
    let force_list : Country.force list = [{force_factor = 3; modernization_level = 1; readiness = 10; pinned = 0}] in
    let player_response : proposed_action = DeployForces ("US", "EU", force_list) in (* of proposed_action *)

    if validator player_response then player_response else get_proposed_action curr_state player_name ~validator

  (* Helpers *)
  let validate_card (gs: t) (player : string) (card_num : string) : bool =
    let open Option.Let_syntax in
    let found = Map.find gs.player_decks player >>= List.find ~f:(fun c -> String.equal c.card_number card_num) in
    match found with
      | Some c -> 
          (match c.play_cost with
            | Some cost -> (Map.find_exn gs.countries player).parameters.resources >= cost
            | None -> true)
      | None -> false

  let validate_procurement (gs: t) (player: string) (wanted_force : string * Country.force) : bool =
    let (_, force) = wanted_force in
    let player_country = Map.find_exn gs.countries player in
    if player_country.parameters.national_tech_level < force.modernization_level then false else
      let cost = Resolution.ActionCostImpl.get_cost gs.resolution_tables Resolution.PROCUREMENT (force.force_factor, force.modernization_level) in
      cost <= (Map.find_exn gs.countries player).parameters.resources
  
  let validate_modernization (gs: t) (player: string) (old_force : string * Country.force) : bool = 
    

  let validate_action (gs: t) (player: string) (act : proposed_action) : bool =
    match act with (* Add code for checking whether these params are actually valid *)
      | PlayCards c -> validate_card gs player c
      | ProcureForce wanted_force -> validate_procurement gs player wanted_force
      | ModernizeForce _ -> false
      | DeployForces _ -> false
      | InitiateCombat _ -> false
      | BuybackReadiness _ -> false
      | Done -> true

  let validate_response (gs: t) (player: string) (response : proposed_action) : bool =
    match response with
      | DeployForces _
      | InitiateCombat _ 
      | Done -> validate_action gs player response
      | _ -> false

  let play_card (curr_state : t) (c : card): t =
    List.fold c.involved ~init:(curr_state, PlayerCountryMap.empty) ~f:(fun (state, response_map) player_name ->
      (* Add code for getting multiple response actions from each player *)
    ) |>
    (fun (new_state, response_map) -> Deck.evaluate_card_result c new_state response_map)
end