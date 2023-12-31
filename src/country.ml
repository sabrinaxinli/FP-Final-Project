open Core
(* open Yojson *)


type parameters = {
  modifier : int;
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

  let of_string_exn (str: string) : t =
    try
      Sexp.of_string str |> t_of_sexp
    with
      | _ -> failwith ("AreaKey.of_string_exn: unknown key '" ^ str ^ "'")

  let of_string (str: string) : t option =
    try
      Sexp.of_string str |> t_of_sexp |> Option.some
    with
    | _ -> None

  let is_region (str: string) : bool =
    match of_string str with
      | Some _ -> true
      | None -> false
  
  let to_string (key: t) : string =
    (sexp_of_t key) |> Sexp.to_string
end

module AORMap = Core.Map.Make(AreaKey)

type force = {
  force_factor: int;
  modernization_level: int;
  readiness: int; (* originally 0-1, but we convert this to 0 - 10 *)
  pinned: int;
} [@@ deriving yojson]

let force_equal (f1 : force) (f2 : force) : bool =
  Int.equal f1.modernization_level f2.modernization_level && 
  Int.equal f1.readiness f2.readiness

let equal_and_greater_force (f1: force) (f2: force) : bool =
  (force_equal f1 f2) && (f1.force_factor >= f2.force_factor)

type aor_map = (force list) AORMap.t (*force factor x modernization level x readiness *)

let aor_map_to_yojson (m: aor_map) : Yojson.Safe.t =
  `Assoc (Core.Map.to_alist m |> List.map ~f:(fun (k, force_list) ->
    let regional_forces = List.fold force_list ~init:[] ~f:(fun acc ele -> (force_to_yojson ele) :: acc) in
    (AreaKey.to_string k), (`List regional_forces)))

let aor_map_of_yojson (json: Yojson.Safe.t) : (aor_map, string) result = 
  let open Result.Monad_infix in
  match json with 
  | `Assoc ls ->
    List.fold_result ls ~init:AORMap.empty ~f:(fun map (k, v) ->
      match v with
      | `List regional_forces ->
        List.fold_result regional_forces ~init:[] ~f:(fun forces r_f ->
          force_of_yojson r_f >>=
          fun troop -> Ok (troop :: forces)
        ) >>=
        fun forces -> Ok (Map.add_exn map ~key:(AreaKey.of_string_exn k) ~data:(List.rev forces))
      | _ -> Error "did not find list of forces"
    )
  | _ -> Error "JSON should be an assoc list"
    

type country_name = US | NATO_EU | PRC | RU | DPRK | IR [@@deriving yojson]
type affiliation = RED | BLUE | WHITE [@@deriving yojson]

type country_data = {
  name: string;
  home_region: string;
  parameters: parameters;
  critical_capabilities: critical_capabilities;
  forces: aor_map; [@to_yojson aor_map_to_yojson] [@of_yojson aor_map_of_yojson]
  npc: bool;
  affiliation: affiliation;
} [@@deriving yojson]

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

module CountryImpl : Country = struct
  type t = country_data

  let deserialize_country_list (lst : Yojson.Safe.t list) : t list =
    List.map ~f:(fun ele -> 
                  match country_data_of_yojson ele with
                    | Ok data -> data
                    | Error _ -> failwith "Error with element") lst

  let create (initial_data : string) : t list =
    match Yojson.Safe.from_file (initial_data) with
      | `List lst -> deserialize_country_list lst
      | _ -> failwith "Did not find json list"

  let get_force_in_region (cd: t) (region: string): force list option =
    let open Option.Let_syntax in
    (AreaKey.of_string region) >>= Map.find cd.forces

  let has_force (cd : t) (region: string) (troop: force) : bool =
    let open Option.Let_syntax in
    match (get_force_in_region cd region) >>= List.find ~f:(fun force -> equal_and_greater_force force troop) with
      | Some _ -> true
      | None -> false

  let update_resources (cd : t) (amount : int) : t =
    let updated_params = {cd.parameters with resources = cd.parameters.resources + amount} in
    {cd with parameters = updated_params}

  let get_turn_resources (cd : t) : t =
    update_resources cd cd.parameters.per_turn_resources

  (* Main helper function for accessing nested data struct *)
  let update_troop_helper ~(map: aor_map) ~(region: string) ~(condition: force -> bool) ~(transform: force -> force option) ~(fallback: force -> force option) ~(default: unit -> (force list) option) : aor_map =
    Map.change map (AreaKey.of_string_exn region) ~f:(function
      | Some troops -> Some (List.filter_map troops ~f:(fun record -> 
          if condition record then transform record else fallback record))
      | None -> default ())

  (* Common params for main helper function *)
  let update_forces (cd : t) (region : string) (new_troop: force) (cost: int) ~(transform: force -> force option) ~(default: unit -> (force list) option) : t =
    let updated_params = { cd.parameters with resources = cd.parameters.resources - cost } in
    let updated_map = 
      update_troop_helper
        ~map:cd.forces
        ~region
        ~condition: (fun record -> force_equal record new_troop)
        ~transform
        ~fallback: (fun record -> Some record)
        ~default
    in
    { cd with parameters = updated_params; forces = updated_map }

  (* Combat and force maintenance procedures *)
  (* This is the result of an ACCEPTED ACTION - the player does not do this themselves; a check is needed for RP and mod_level *)

  let procure_forces (cd : t) (region: string) (new_troop: force) (cost: int): t =
    update_forces cd region new_troop cost
    ~transform: (fun record -> Some {record with force_factor = record.force_factor + new_troop.force_factor})
    ~default: (fun () -> Some [{ new_troop with force_factor = new_troop.force_factor }])


  (* A check is needed by the facilitator for RP and mod level *)
  let modernize_forces (cd : t) (region : string) (new_troop: force) (upgrade : int) (cost: int): t =
    update_forces cd region new_troop cost
    ~transform: (fun record -> Some {record with modernization_level = record.modernization_level + upgrade})
    ~default: (fun () -> None)

  (* let deploy_forces (cd : t) (source_dest_troop: (string * string * force) list) (costs: int list): t =
    List.fold (List.zip_exn source_dest_troop costs) ~init:cd ~f:(fun acc ((source, dest, troop), cost) ->
      update_forces acc source troop cost 
      ~transform: (fun record -> if record.force_factor = troop.force_factor then None else Some {record with force_factor = record.force_factor - troop.force_factor}) 
      ~default: (fun () -> None) |>
      (fun m -> procure_forces m dest troop 0)
    ) *)

  let deploy_forces (cd : t) (source_dest_troops: string * string * force list) (cost: int): t =
    let (source, dest, force_list) = source_dest_troops in
    (List.fold force_list ~init:cd ~f:(fun acc troop -> 
      update_forces acc source troop 0
      ~transform: (fun record -> if record.force_factor = troop.force_factor then None else Some {record with force_factor = record.force_factor - troop.force_factor})
      ~default: (fun () -> None) |>
      (fun m -> procure_forces m dest troop 0))) |>
    (fun updated -> update_resources updated (-cost))

  let apply_combat_results (cd : t) (involved: string * force list) (battle_result: Resolution.outcome) (reset: bool) (pinned: int) (ip_change: int): t =
    let updated_params = {cd.parameters with influence_points = cd.parameters.influence_points + ip_change} in
    let (region, troops) = involved in
    let result = List.fold troops ~init:cd ~f:(fun acc troop ->
      let withdrawn_troops = if reset then troop.force_factor / 2 else 0 in
      let result_readiness = if String.equal cd.name "US" then
          match battle_result with
            | Resolution.RED_MAJOR_GAIN -> max (troop.readiness - 3) 0
            | Resolution.RED_MINOR_GAIN -> max (troop.readiness - 2) 0
            | _ -> max (troop.readiness - 1) 0
        else
          0
      in
      update_forces acc region troop 0
        ~transform: (fun record -> Some {record with force_factor = record.force_factor - withdrawn_troops; readiness = result_readiness; pinned = pinned})
        ~default: (fun () -> None) |>
      (fun x -> procure_forces x cd.home_region troop 0)
    ) in
    {result with parameters = updated_params}

  let buyback_readiness (cd : t) (troop: string * force list) (readiness: int) (cost: int): t =
    let (region, units) = troop in
    List.fold units ~init:cd ~f:(fun acc curr -> 
      update_forces acc region curr 0
      ~transform: (fun record -> Some {record with readiness = record.readiness + readiness})
      ~default: (fun () -> None)
    ) |>
    (fun x -> update_resources x (-cost))

  let can_afford (cd: t) (res_tables : Resolution.ActionCostImpl.t) (action_type: Resolution.tabletype) (key : int * int) : int option =
    let open Option.Let_syntax in
    Resolution.ActionCostImpl.get_cost res_tables action_type key >>=
    (fun cost -> if cd.parameters.resources >= cost then Some cost else None)

end


(* Legacy implementations *)

(* let procure_forces (cd : t) (region: string) (new_troop: force) (cost: int): t =
    let updated_params = {cd.parameters with resources = (cd.parameters.resources - cost)} in
    let key = (AreaKey.of_string region) in
    let updated_map = Map.update cd.forces key ~f:(function
      | Some troops -> (List.map troops ~f:(fun record -> 
          if (force_equal record new_troop) then {record with force_factor = record.force_factor + new_troop.force_factor}
          else record))
      | None -> [{force_factor = new_troop.force_factor; modernization_level = new_troop.modernization_level; readiness = new_troop.readiness}]) in
    {cd with forces = updated_map; parameters = updated_params} *)

(* let modernize_forces (cd : t) (region : string) (new_troop: force) (upgrade : int) (cost: int): t =
    let updated_params = {cd.parameters with resources = (cd.parameters.resources - cost)} in
    {cd with 
    forces = Map.update cd.forces (AreaKey.of_string region) ~f:(function
        | Some v -> (List.map troops ~f: (fun record -> )
          {v with modernization_level = v.modernization_level + upgrade}
        | None -> failwith "No forces to modernize");
    parameters = updated_params} *)


(* let deploy_forces (cd : t) (source_num_dest: (string * int * string) list) : t =
let updated_map = List.fold source_num_dest ~init:cd.forces ~f:(fun acc (source, num_troops, dest) ->
  Map.update acc (AreaKey.of_string source) ~f:(function 
  | Some old_forces -> {old_forces with force_factor = (old_forces.force_factor - num_troops)}
  | None -> failwith "Missing source troops") |>
  Map.update (AreaKey.of_string dest) ~f:(function
  | Some old_forces -> {old_forces with force_factor = (old_forces.force_factor - num_troops)}
  | None -> {force_factor = num_troops})
  ) *)
