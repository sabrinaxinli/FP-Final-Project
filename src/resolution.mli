(* module type TestExample = sig
  type t = int
  val get_i: int -> int
end *)

type tabletype = PROCUREMENT | MODERNIZATION | DEFAULT

type outcome = RED_MAJOR_GAIN | RED_MINOR_GAIN | STATUS_QUO | BLUE_MINOR_GAIN | BLUE_MAJOR_GAIN

type resolution_table

module type ActionCost = sig
  type t
  type k = int * int
  val get_table_map: unit -> t
  val get_cost: t -> tabletype -> k -> int
end

module ActionCostImpl : ActionCost