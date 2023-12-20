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
  modifier : int;
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
  val of_string : string -> t option
  val of_string_exn : string -> t
  val to_string : t -> string
  val is_region: string -> bool
end

module AORMap : Core.Map.S with type Key.t = AreaKey.t

type force = {
  force_factor: int;
  modernization_level: int;
  readiness: int;
  pinned: int;
}

val force_equal: force -> force -> bool

val force_to_yojson: force -> Yojson.Safe.t
val force_of_yojson: Yojson.Safe.t -> (force, string) result

type aor_map = (force list) AORMap.t

val aor_map_to_yojson: aor_map -> Yojson.Safe.t
val aor_map_of_yojson: Yojson.Safe.t -> (aor_map, string) result

type country_name = US | NATO_EU | PRC | RU | DPRK | IR
type affiliation = RED | BLUE | WHITE

val country_name_to_yojson: country_name -> Yojson.Safe.t
val country_name_of_yojson: Yojson.Safe.t -> (country_name, string) result

val affiliation_to_yojson: affiliation -> Yojson.Safe.t
val affiliation_of_yojson: Yojson.Safe.t -> (affiliation, string) result


type country_data = {
  name: string;
  home_region: string;
  parameters: parameters;
  critical_capabilities: critical_capabilities;
  forces: aor_map;
  npc: bool;
  affiliation: affiliation;
}

val country_data_to_yojson: country_data -> Yojson.Safe.t
val country_data_of_yojson: Yojson.Safe.t -> (country_data, string) result

(* type aor = CONUS | INDOPACOM_PRC | INDOPACOM_DPRK | CENTCOM_IRAN | CENTCOM_AFGHANISTAN | CENTCOM_IRAQ | EUCOM_RU *)
(* type country_name = US | NATO_EU | PRC | RU | DPRK | IR *)
(* type affiliation = RED | BLUE | WHITE *)

module type Country = sig
	type t = country_data
	val create: string -> t list
	val get_force_in_region: t -> string -> force list option
	val has_force: t -> string -> force -> bool
	val get_turn_resources: t -> t
  
	(* Combat and force maintenance procedures *)
	val procure_forces: t -> string -> force -> int -> t
	val modernize_forces: t -> string -> force -> int -> int -> t
	val deploy_forces: t -> (string * string * force list) -> int -> t
	val apply_combat_results: t -> string * force list -> Resolution.outcome -> bool -> int -> int -> t
	val update_resources: t -> int -> t
	val buyback_readiness: t -> string * force list -> int -> int -> t
	val can_afford: t -> Resolution.ActionCostImpl.t -> Resolution.tabletype -> int * int -> int option
  end

module CountryImpl : Country

(* module MakeCountry (_ : sig val initial_data: string end) : Country *)

