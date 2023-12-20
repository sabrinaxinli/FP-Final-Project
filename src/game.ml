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

let get_current_countries (map : player_country_map) : string list =
  Map.keys map

type proposed_action =
  | PlayCards of string
  | ProcureForce of string * Country.force
  | ModernizeForce of string * Country.force * int
  | DeployForces of string * string * Country.force list
  | InitiateCombat of string * string * Country.force list
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

  val load_cards: string -> t list
	val get_size: t list -> int
  val sorted_by: t list -> string -> t list
  val build_card_mappings: unit -> m
  val get_card_function: m -> string -> card_function

  (* Card mechanics *)
  val evaluate_card_result: t -> game_data -> player_responses_map -> game_data
end

module DeckImpl : Deck = struct
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

  (* TO BE IMPLEMENTED*)
  let sorted_by (card_list: t list) (_: string) : t list =
    card_list

  (* Helper function for checking if a player responded *)
  (* let empty_action (prm: player_responses_map) (player_name : string) : bool =
    List.length (Map.find_exn prm player_name) = 1 *)

  let build_card_mappings () : m =
    StringMap.empty
    (* |> Map.add_exn ~key:"PRC-01" ~data:(fun c gd prm ->
      let modifier = if (empty_action prm "US") then Resolution.RED_ADVANTAGE else Resolution.PARITY in

      (* Use RT B *)) *)

  let get_card_function (map : m) (card_num: string) : (card -> game_data -> player_responses_map -> game_data) =
    Map.find_exn map card_num

  (* This is purely for evaluating the result of the card. The players should be given the card info in the Gamestate module and
     allowed to respond first before this function is called. *)
  let evaluate_card_result (_ : t) (curr_state: game_data) (_ : player_responses_map): game_data =
    curr_state
end

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

end

module GameStateImpl : GameState = struct
  type t = game_data

  let start_game ~(countries_fp: string) ~(player_decks_dir : string) ~(domestic_fp : string) ~(int_fp : string) : t =
    let country_datas = Country.CountryImpl.create countries_fp in
    let resolutions = Resolution.ActionCostImpl.get_table_map () in
    let player_decks = 
      try
        let deck_dirs = Sys_unix.readdir player_decks_dir in
        let decks = 
          List.fold (Array.to_list deck_dirs) ~init:StringMap.empty ~f:(fun map deck_dir ->
            let full_deck_dir = Filename.concat player_decks_dir deck_dir in
            let card_list = DeckImpl.load_cards full_deck_dir in
            List.fold card_list ~init:map ~f:(fun acc c -> 
              Map.update acc c.player ~f:(function
                | None -> [c]
                | Some cards -> c :: cards)
            ))
        in
        decks
      with
      | Sys_error err -> failwith ("Could not access player_decks_dir: " ^ err)
    in
    let domestic_deck = DeckImpl.load_cards domestic_fp in
    let international_deck = DeckImpl.load_cards int_fp in
    {countries = List.fold country_datas ~init:StringMap.empty ~f:(fun map x -> Map.add_exn map ~key:x.name ~data:x);
    player_decks = player_decks;
    domestic_event_deck = domestic_deck;
    international_event_deck = international_deck;
    victory_conditions = StringMap.empty;
    current_turn = "Red Signalling";
    resolution_tables = resolutions}
    

  let rec get_proposed_action (gs: t) (player_name: string) ~(validator: t -> string -> proposed_action -> int option): proposed_action * int =
    (* Instead of hard-coding the response from a player like below; add a server call *)
    (* I haven't yet written a serializer/deserializer for the player_country_map yet, but you can use the proposed_action
       serialize / deserializers to help *)
    let force_list : Country.force list = [{force_factor = 3; modernization_level = 1; readiness = 10; pinned = 0}] in
    let player_response : proposed_action = DeployForces ("US", "EU", force_list) in (* of proposed_action *)

    match validator gs player_name player_response with 
      | Some cost -> (player_response, cost)
      | None -> get_proposed_action gs player_name ~validator

  (* --- Helpers for validation ----- *)
  let validate_card (player_country: Country.country_data) (player_deck : card list) (card_num : string) : int option =
    let open Option.Let_syntax in
    List.find player_deck ~f:(fun c -> String.equal c.card_number card_num) >>=
    (fun card -> card.play_cost) >>=
    (fun play_cost -> if player_country.parameters.resources >= play_cost then Some play_cost else None)

  let validate_procurement (player_country: Country.country_data) (res_table : Resolution.ActionCostImpl.t) (region : string) (force : Country.force) : int option =
    if (player_country.parameters.national_tech_level >= force.modernization_level) && (Country.AreaKey.is_region region) then
      Country.CountryImpl.can_afford player_country res_table Resolution.PROCUREMENT (force.force_factor, force.modernization_level) 
    else None
  
  let validate_modernization (player_country: Country.country_data) (res_table : Resolution.ActionCostImpl.t) (region : string) (force : Country.force) (upgrade : int) : int option= 
    if (player_country.parameters.national_tech_level >= (force.modernization_level + upgrade)) && (Country.CountryImpl.has_force player_country region force) then
      Country.CountryImpl.can_afford player_country res_table Resolution.MODERNIZATION (force.force_factor, upgrade)
    else None
  
  let validate_deployment (player_country: Country.country_data) (res_table : Resolution.ActionCostImpl.t) (source : string) (dest: string) (forces : Country.force list) (response: bool): int option =
    if List.fold forces ~init:true ~f:(fun acc x -> acc && Country.CountryImpl.has_force player_country source x) && (Country.AreaKey.is_region dest) then
      let total_troops = List.fold forces ~init:0 ~f:(fun acc x  -> acc + x.force_factor) in
      Country.CountryImpl.can_afford player_country res_table Resolution.DEPLOYMENT (total_troops, if response then 1 else 0)
    else None
  
  let validate_combat_initiation (player_country: Country.country_data) (country_map : player_country_map) (target: string) (region : string) (personal_forces: Country.force list) : int option =
    if (Map.mem country_map target) && (List.for_all personal_forces ~f:(fun force -> Country.CountryImpl.has_force player_country region force)) then
      Some 0
    else
      None
  
  (* Helper function for getting the readiness cost for US player buyback *)
  let get_readiness_cost (player_country: Country.country_data) (region: string) (troops : Country.force list) (readiness: int): int =
    let total_troops = List.fold troops ~init:0 ~f:(fun acc x -> acc + x.force_factor) in
    if String.equal player_country.name "US" then
        if String.equal region "CONUS" then 
          (total_troops + readiness) 
        else 
          int_of_float (Float.round_up (float_of_int total_troops *. 1.3) +. Float.round_down (float_of_int readiness *. 1.2))
    else
      total_troops
  
  let validate_buyback (player_country: Country.country_data) (region: string) (unreadied_troops : Country.force list) (readiness: int) : int option =
    if (Country.AreaKey.is_region region) && List.for_all unreadied_troops ~f:(fun troop -> (Country.CountryImpl.has_force player_country region troop) && ((troop.readiness + readiness) <= 10)) then
      Some (get_readiness_cost player_country region unreadied_troops readiness)
    else
      None

  (* ------ End helper functions for validation *)
  
  (* Separating out functionality for validation and enaction to allow for future expansion of facilitator role *)
  let validate_action (gs: t) (player: string) (act : proposed_action) : int option =
    let player_country = Map.find_exn gs.countries player in
    match act with
      | PlayCards card_num -> validate_card player_country (Map.find_exn gs.player_decks player) card_num
      | ProcureForce (region, force) -> validate_procurement player_country gs.resolution_tables region force
      | ModernizeForce (region, force, upgrade) -> validate_modernization player_country gs.resolution_tables region force upgrade
      | DeployForces (source, dest, forces) -> validate_deployment player_country gs.resolution_tables source dest forces false
      | InitiateCombat (target, region, personal_forces) -> validate_combat_initiation player_country gs.countries target region personal_forces 
      | BuybackReadiness (region, troops, readiness) -> validate_buyback player_country region troops readiness
      | Done -> Some 0
  
  let validate_response (gs: t) (player: string) (response : proposed_action) : int option =
    let player_country = Map.find_exn gs.countries player in
    match response with
      | DeployForces (source, dest, forces) -> validate_deployment player_country gs.resolution_tables source dest forces true
      | InitiateCombat _ 
      | Done -> validate_action gs player response
      | _ -> Some 0

  let enact_action (gs: t) (player : string) (act : proposed_action) (cost : int): t =
    let player_country = Map.find_exn gs.countries player in
    match act with
      | PlayCards _ -> gs (* TO BE IMPLEMENTED - add play_card functionality *)
      | ProcureForce (region, force) ->
          let updated_player = Country.CountryImpl.procure_forces player_country region force cost in
          {gs with countries = Map.update gs.countries player ~f:(function | Some _ -> updated_player | None -> failwith "player must exist for procurement")}
      | ModernizeForce (region, force, upgrade) ->
          let updated_player = Country.CountryImpl.modernize_forces player_country region force upgrade cost in
          {gs with countries = Map.update gs.countries player ~f:(function | Some _ -> updated_player | None -> failwith "player must exist for modernization")}
      | DeployForces (source, dest, forces) ->
          let updated_player = Country.CountryImpl.deploy_forces player_country (source, dest, forces) cost in
          {gs with countries = Map.update gs.countries player ~f:(function | Some _ -> updated_player | None -> failwith "player must exist for deployment")}
      | InitiateCombat _ -> gs (* let (target, region, personal_forces) = involved in *)
      | BuybackReadiness (region, force_list, readiness) ->
          let updated_player = Country.CountryImpl.buyback_readiness player_country (region, force_list) readiness cost in
          {gs with countries = Map.update gs.countries player ~f:(function | Some _ -> updated_player | None -> failwith "player must exist for buyback")}
      | Done -> gs

  (* Code stub for play_card - TO BE IMPLEMENTED *)
  (* let play_card (curr_state : t) (c : card): t =
    List.fold c.involved ~init:(curr_state, PlayerCountryMap.empty) ~f:(fun (state, response_map) player_name ->
      (* Add code for getting multiple response actions from each player *)
    ) |>
    (fun (new_state, response_map) -> Deck.evaluate_card_result c new_state response_map) *)

  let update_resource_allocations (gs: t) : t =
    {gs with countries = Map.map gs.countries ~f:(fun cd -> Country.CountryImpl.get_turn_resources cd)}
end