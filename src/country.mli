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

type aor = CONUS | INDOPACOM_PRC | INDOPACOM_DPRK | CENTCOM_IRAN | CENTCOM_AFGHANISTAN | CENTCOM_IRAQ | EUCOM_RU
type country_name = US | NATO_EU | PRC | RU | DPRK | IR
type affliation = RED | BLUE | WHITE

(* Fix this deriving situation later *)
module type AOR_Key = sig
  type t = aor
  [@@deriving compare]
end

module AOR_Map = Map.Make(AOR_Key)

type combat_resources = {
  critical_capabilities: critical_capabilities;
  forces: (int * int) AOR_Map.t
}

type country_data = {
  country_name : country_name;
  affliation: affliation;
  parameters: parameters;
  combat_resources: combat_resources;
}


module type Country = sig
  type t (* should we break up t from one country_data object to multiple? *)
  val create: country_name -> country_data -> t
  val get_player_name : t -> country_name
  val get_force_size : t -> int
  val get_national_tech_level: t -> int
  val get_resources: t -> int
  val get_per_turn_resources: t -> int
  val get_influence_points: t -> int
  val lrf: t -> int
  val c4isr: t -> int
  val iamd_bmd: t -> int
  val sof: t -> int
  val nuclear_forces: t -> int
  val get_aor: t -> (int * modifier) list
  val get_ip: t -> int
  (* Combat and force maintenance procedures *)
  val procure_forces: t -> t
  val modernize_forces: t -> t
  val deploy_forces: t -> t
  val apply_combat_results: t -> t
  val update_resources: t -> t
  
end

module MakeCountry (State : sig val initial_data: country_data end) : Country

