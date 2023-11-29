open Core;;
open Yojson;;

type parameters = {
  force_size : int;
  national_tech_level: int;
  resources: int;
  per_turn_resources: int;
  influence_points: int;
}

type critical_capabilities = {
  lrf: int;
  c4isr: int;
  iamd_bmd: int;
  sof: int;
  nuclear_forces: int;
}

module AOR_Key = struct
  type t = 
    | CONUS 
    | INDOPACOM_PRC
    | INDOPACOM_DPRK
    | CENTCOM_IRAN
    | CENTCOM_AFGHANISTAN
    | CENTCOM_IRAQ
    | EUCOM_RU
  [@@deriving sexp, compare]
end

module AOR_Map = Map.Make(AOR_Key)


type combat_resources = {
  critical_capabilities: critical_capabilities;
  forces: (int * int) AOR_Map.t
}

type aor = CONUS | INDOPACOM_PRC | INDOPACOM_DPRK | CENTCOM_IRAN | CENTCOM_AFGHANISTAN | CENTCOM_IRAQ | EUCOM_RU

type country_data = {
  parameters: parameters;
  combat_resources: combat_resources;
  npc: bool;
}

type country_name = US | NATO_EU | PRC | RU | DPRK | IR

module type Country = sig
  type t = country_data
  val create: unit -> t
  val get_player_name : t -> country_name
  val get_force_size : t -> int
  val get_national_tech_level: t -> int
  val get_resources: t -> int
  val get_per_turn_resources: t -> int
  val get_influence_points: t -> int
  val lrf: t -> int
  val c4isr: t -> int
  val iamd_bmd: t -> int
  val sof: unit -> t
  val nuclear_forces: t -> int
  val get_aor: t -> AOR_Map
  val get_ip: t -> int
  val get_npc: t -> bool
  val get_action: t -> gamestate
end

module MakeCountry (State : sig val initial_data: string end) : Country = struct
  type t = country_data
  let create : t =
    let json = Yojson.Basic.from_file (State.initial_data) in
    let open Yojson.Basic.Util in
    let title = json |> member "title" |> to_string in
    let tags = json |> member "tags" |> to_list |> filter_string in
    let pages = json |> member "pages" |> to_int in
end

module US = MakeCountry(struct let initial_data = us_data end)

let us = USCountry.create US us_data

