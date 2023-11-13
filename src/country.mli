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

(* Fix this later *)
type modifier = {
  parameter: int
}

type aor = {
    aor_list: (int * modifier) list
}

type country_state = {
  parameters: parameters;
  critical_capabilities: critical_capabilities;
  aor: aor;
}

module type CountryState = sig
  type t
end

module type Country = sig
  type t
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
  (* Add more *)
end

module MakeCountry (State : CountryState) : Country
