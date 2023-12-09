(******************************************************************************

  File: country.mli

  Project: Command & Converse

  Author: Adam Byerly & Sabrina Li

  Description:                                                              
  This file contains defines types and moduels for representing and managing
  countries within the game 'Hedgemony.' It includes types for basic country
  parameters, critical military and strategic capabilities, and area of
  responsibility modifiers.                                     
                                                                             
******************************************************************************)
open Core

type parameters = {
  force_size : int;
  national_tech_level: int;
  resources: int;
  per_turn_resources: int;
  influence_points: int;
}

val parameters_to_yojson : parameters -> Yojson.Safe.t
val parameters_of_yojson : Yojson.Safe.t -> (parameters, string) result

type critical_capabilities = {
  lrf: int;
  c4isr: int;
  iamd_bmd: int;
  sof: int;
  nuclear_forces: int;
}

val critical_capabilities_to_yojson : critical_capabilities -> Yojson.Safe.t
val critical_capabilities_of_yojson : Yojson.Safe.t -> (critical_capabilities, string) result


module AreaKey : sig
  type t
  val of_string : string -> t
  val to_string : t -> string
end

module AORMap : Core.Map.S with type Key.t = AreaKey.t

type aor_map

val aor_map_to_yojson: aor_map -> Yojson.Safe.t
val aor_map_of_yojson: Yojson.Safe.t -> (aor_map, string) result

type combat_resources = {
  critical_capabilities: critical_capabilities;
  forces: aor_map
}

val combat_resources_to_yojson: combat_resources -> Yojson.Safe.t
val combat_resources_of_yojson: Yojson.Safe.t -> (combat_resources, string) result

type country_data = {
  name: string;
  parameters: parameters;
  combat_resources: combat_resources;
  npc: bool;
  affiliation: string;
}

val country_data_to_yojson: country_data -> Yojson.Safe.t
val country_data_of_yojson: Yojson.Safe.t -> (country_data, string) result

(* type aor = CONUS | INDOPACOM_PRC | INDOPACOM_DPRK | CENTCOM_IRAN | CENTCOM_AFGHANISTAN | CENTCOM_IRAQ | EUCOM_RU *)
(* type country_name = US | NATO_EU | PRC | RU | DPRK | IR *)
(* type affiliation = RED | BLUE | WHITE *)



module type Country = sig
  type t = country_data
  val create: unit -> t list
  val get_player_name : t -> string
  val get_force_size : t -> int
  val get_force_in_region: t -> string -> int
  val get_national_tech_level: t -> int
  val get_resources: t -> int
  val get_per_turn_resources: t -> int
  val get_influence_points: t -> int
  val get_lrf: t -> int
  val get_c4isr: t -> int
  val get_iamd_bmd: t -> int
  val get_sof: t -> int
  val get_nuclear_forces: t -> int
  val get_aor: t -> string -> int
  val get_ip: t -> int
  val get_npc: t -> bool
  val get_action: t -> string
  (* Combat and force maintenance procedures *)
  val procure_forces: t -> t
  val modernize_forces: t -> t
  val deploy_forces: t -> t
  val apply_combat_results: t -> t
  val update_resources: t -> t
  
end

module MakeCountry (_ : sig val initial_data: string end) : Country

