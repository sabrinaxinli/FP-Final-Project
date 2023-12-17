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
  aor: string option;
  public: bool option;
  play_cost: int option;
  replayable: bool;
} [@@deriving yojson]

module PlayerCountryMap = Map.Make(String)

type player_country_map = Country.t PlayerCountryMap.t


module type Deck = sig
  type t

  val load_cards: unit -> t list (* Will contain logic for data loading for cards from specified path *)
  val get_size: t list -> int
  val sorted_by: t list -> string -> t list (* string contains info to be sorted by *)

  (* Card mechanics *)
  val get_player: t -> string
  val get_card_type: t -> card_type
  val get_title: t -> string
  val get_description: t -> string
  val get_card_number: t -> string
  val get_aor: t -> string option
  val get_public: t -> bool option
  val get_play_cost: t -> int option
  val get_replayable: t -> bool
  val execute_card: t -> player_country_map -> player_country_map
end

type player_decks = (card list) PlayerCountryMap.t

type victory_conditions_map = bool PlayerCountryMap.t

module MakeDeck(LoadData: sig val filepath: string end) : Deck = struct
  type t = card

  let deserialize_card_list (lst : Yojson.Safe.t list) : t list =
    List.map ~f:(fun ele -> 
                  match card_of_yojson ele with
                    | Ok data -> data
                    | Error _ -> failwith "Error with element") lst

  let load_cards () : t list =
    match Yojson.Safe.from_file (LoadData.filepath) with
      | `List lst -> deserialize_card_list lst
      | _ -> failwith "Did not find json list"

  let get_size (card_list: t list) : int =
    List.length card_list

  (* Implement later *)
  let sorted_by (card_list: t list) (_: string) : t list =
    card_list

  let get_player (c : t) : string =
    c.player

  let get_card_type (c : t) : card_type =
    c.card_type

  let get_title (c : t) : string =
    c.title

  let get_description (c : t) : string =
    c.description

  let get_card_number (c : t) : string = 
    c.card_number

  let get_aor (c: t) : string option =
    c.aor

  let get_public (c : t): bool option =
    c.public

  let get_play_cost (c : t): int option =
    c.play_cost

  let get_replayable (c : t) : bool =
    c.replayable

  let execute_card (_ : t) (player_infos: player_country_map) : player_country_map =
    player_infos

end

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