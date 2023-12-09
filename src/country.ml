open Core
(* open Yojson *)


type parameters = {
  force_size : int;
  national_tech_level: int;
  resources: int;
  per_turn_resources: int;
  influence_points: int;
} [@@deriving yojson]

type critical_capabilities = {
  lrf: int;
  c4isr: int;
  iamd_bmd: int;
  sof: int;
  nuclear_forces: int;
} [@@deriving yojson]

module AreaKey = struct
  type t = 
  | CONUS 
  | INDOPACOM_PRC
  | INDOPACOM_DPRK
  | CENTCOM_IRAN
  | CENTCOM_AFGHANISTAN
  | CENTCOM_IRAQ
  | EUCOM_RU
  [@@deriving sexp, compare]

  let of_string (str: string) : t =
    Sexp.of_string str |> t_of_sexp
  
  let to_string (key: t) : string =
    (sexp_of_t key) |> Sexp.to_string

end


module AORMap = Core.Map.Make(AreaKey)
type aor_map = int AORMap.t

let aor_map_to_yojson (m: aor_map) : Yojson.Safe.t =
  `Assoc (Core.Map.to_alist m |> List.map ~f:(fun (k, v) -> (AreaKey.to_string k), `Int v))

let aor_map_of_yojson (json: Yojson.Safe.t) : (aor_map, string) result = 
  match json with 
    | `Assoc ls -> Ok (List.fold ls ~init: AORMap.empty ~f:(fun acc (k, v) -> 
        match v with
          | `Int i -> Map.add_exn acc ~key: (AreaKey.of_string k) ~data:i
          | _ -> failwith "should be int"))
    | _ -> Error "should not be anything other than an assoc list"

type combat_resources = {
  critical_capabilities: critical_capabilities;
  forces: aor_map [@to_yojson aor_map_to_yojson] [@of_yojson aor_map_of_yojson]
} [@@deriving yojson]

(* type country_name = US | NATO_EU | PRC | RU | DPRK | IR *)
(* type affiliation = RED | BLUE | WHITE *)

type country_data = {
  name: string;
  parameters: parameters;
  combat_resources: combat_resources;
  npc: bool;
  affiliation: string;
} [@@deriving yojson]

module type Country = sig
  type t = country_data
  val create: unit -> t
  val get_player_name : t -> string
  val get_force_size : t -> string -> int
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

module MakeCountry (State : sig val initial_data: string end) : Country = struct
  type t = country_data

  let create (): t =
    match Yojson.Safe.from_file (State.initial_data) |> country_data_of_yojson with
      | Ok data -> data
      | Error _ -> failwith "Error received"

  let get_player_name (cd : t) : string =
    cd.name
    
  let get_force_size (cd: t) (region: string): int =
    Map.find_exn cd.combat_resources.forces (AreaKey.of_string region)
  
  let get_national_tech_level (cd: t) : int =
    cd.parameters.national_tech_level
  
  let get_resources (cd: t) : int =
    cd.parameters.resources

  let get_per_turn_resources (cd: t) : int =
    cd.parameters.per_turn_resources

  let get_influence_points (cd: t) : int =
    cd.parameters.influence_points

  let get_lrf (cd: t) : int = 
    cd.combat_resources.critical_capabilities.lrf
  
  let get_c4isr (cd: t) : int =
    cd.combat_resources.critical_capabilities.c4isr

  let get_iamd_bmd (cd: t): int =
    cd.combat_resources.critical_capabilities.iamd_bmd

  let get_sof (cd: t) : int =
    cd.combat_resources.critical_capabilities.sof

  let get_nuclear_forces (cd: t) : int =
    cd.combat_resources.critical_capabilities.nuclear_forces
  
  let get_aor (_ : t) (_ : string) : int =
    10 (* Temporary value *)
  
  let get_ip (cd: t) : int =
    cd.parameters.influence_points
  
  let get_npc (cd: t) : bool =
    cd.npc
  
  let get_action (_: t) : string =
    "action statement"
  
  (* Combat and force maintenance procedures *)
  let procure_forces (cd : t) : t =
    cd
  
  let modernize_forces (cd : t) : t =
    cd

  let deploy_forces (cd : t) : t =
    cd

  let apply_combat_results (cd : t): t =
    cd
  
  let update_resources (cd: t) : t =
    cd
end

(* module US = MakeCountry(struct let initial_data = us_data end)

let us = USCountry.create US us_data *)

