(* module type TestExample = sig
  type t = int
  val get_i: int -> int
end *)

type tabletype = PROCUREMENT | MODERNIZATION | DEPLOYMENT | COMBAT_FACTORS

type resolution_table

module type ActionCost = sig
  type t = resolution_table
  type k = int * int
  val get_table_map: unit -> t
  val get_cost: t -> tabletype -> k -> int option
end

module ActionCostImpl : ActionCost

type outcome = RED_MAJOR_GAIN | RED_MINOR_GAIN | STATUS_QUO | BLUE_MINOR_GAIN | BLUE_MAJOR_GAIN
type advantage = RED_ADVANTAGE | PARITY | BLUE_ADVANTAGE

(* Combat resolution table *)
val resolve_combat : ?roll_dice:(unit -> int) -> int -> int -> int -> outcome

(* Noncombat resolution table *)
val resolve_noncombat : ?roll_dice:(unit -> int) -> advantage -> int -> outcome