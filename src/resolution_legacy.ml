(* module IntPair = struct
  type t = int * int [@@deriving compare, sexp]
end

module IntPairTable = Map.Make(IntPair)

module IntTable = Map.Make(Int)

type tabletype = PROCUREMENT | MODERNIZATION [@@deriving compare, sexp]


type outcome = RED_MAJOR_GAIN | RED_MINOR_GAIN | STATUS_QUO | BLUE_MINOR_GAIN | BLUE_MAJOR_GAIN

module TableType = struct
  type t = PROCUREMENT | MODERNIZATION [@@deriving compare, sexp]
end

module ResolutionTable = Map.Make(TableType)

type cost_table = IntPairTable of (int IntPairTable.t) 

(* IntTable of (int IntTable.t)  *)


type res_table = cost_table ResolutionTable.t *)

module Troops : sig
  type t
  val get_map : unit -> t
end = struct
  type t = int
  
  let get_map () : t = 1
end
  (* let procurement_costs = [
      ((1, 1), 2); ((1, 2), 3); ((1, 3), 4); ((1, 4), 5); ((1, 5), 6); ((1, 6), 7); ((1, 7), 8);
      ((2, 1), 4); ((2, 2), 6); ((2, 3), 8); ((2, 4), 10); ((2, 5), 12); ((2, 6), 14); ((2, 7), 16);
      ((3, 1), 6); ((3, 2), 8); ((3, 3), 10); ((3, 4), 12); ((3, 5), 14); ((3, 6), 16); ((3, 7), 18);
      ((4, 1), 8); ((4, 2), 11); ((4, 3), 14); ((4, 4), 17); ((4, 5), 20); ((4, 6), 23); ((4, 7), 26);
      ((5, 1), 10); ((5, 2), 13); ((5, 3), 16); ((5, 4), 19); ((5, 5), 22); ((5, 6), 25); ((5, 7), 28);
      ((6, 1), 12); ((6, 2), 16); ((6, 3), 20); ((6, 4), 24); ((6, 5), 28); ((6, 6), 32); ((6, 7), 36);
      ((7, 1), 14); ((7, 2), 18); ((7, 3), 22); ((7, 4), 26); ((7, 5), 30); ((7, 6), 34); ((7, 7), 38);
      ((8, 1), 16); ((8, 2), 20); ((8, 3), 24); ((8, 4), 28); ((8, 5), 32); ((8, 6), 36); ((8, 7), 40);
      ((9, 1), 18); ((9, 2), 23); ((9, 3), 28); ((9, 4), 33); ((9, 5), 38); ((9, 6), 43); ((9, 7), 48);
      ((10, 1), 20); ((10, 2), 26); ((10, 3), 32); ((10, 4), 38); ((10, 5), 44); ((10, 6), 50); ((10, 7), 56)]

  let upgrade_costs = [
    ((1, 1), 1); ((1, 2), 2); ((1, 3), 3); ((1, 4), 4); ((1, 5), 5); ((1, 6), 6);
    ((2, 1), 2); ((2, 2), 3); ((2, 3), 4); ((2, 4), 5); ((2, 5), 6); ((2, 6), 7);
    ((3, 1), 3); ((3, 2), 4); ((3, 3), 5); ((3, 4), 6); ((3, 5), 7); ((3, 6), 8);
    ((4, 1), 4); ((4, 2), 5); ((4, 3), 6); ((4, 4), 7); ((4, 5), 8); ((4, 6), 9);
    ((5, 1), 5); ((5, 2), 6); ((5, 3), 7); ((5, 4), 8); ((5, 5), 9); ((5, 6), 10);
    ((6, 1), 6); ((6, 2), 7); ((6, 3), 8); ((6, 4), 9); ((6, 5), 10); ((6, 6), 11);
    ((7, 1), 7); ((7, 2), 8); ((7, 3), 9); ((7, 4), 10); ((7, 5), 11); ((7, 6), 12);
    ((8, 1), 8); ((8, 2), 9); ((8, 3), 10); ((8, 4), 11); ((8, 5), 12); ((8, 6), 13);
    ((9, 1), 9); ((9, 2), 10); ((9, 3), 11); ((9, 4), 12); ((9, 5), 13); ((9, 6), 14);
    ((10, 1), 10); ((10, 2), 11); ((10, 3), 12); ((10, 4), 13); ((10, 5), 14); ((10, 6), 15)] *)

  (* let build_int_pair_table (ls : ((int * int) * int) list) : cost_table =
    IntPairTable (List.fold ls ~init:IntPairTable.empty ~f:(fun acc ((ff, mod_level), cost) -> 
      Map.add_exn acc ~key: (ff, mod_level) ~data: cost)) *)

  (* let build_int_table (ls : (int * int) list) : cost_table = 
    IntTable (List.fold ls ~init:IntTable.empty ~f:(fun acc (key, cost) -> 
      Map.add_exn acc ~key ~data:cost)) *)

  (* let get_table_map () : t =
    5 *)
    (* ResolutionTable.empty *)
    (* |> Map.add_exn ~key:PROCUREMENT ~data: (build_int_pair_table procurement_costs)
    |> Map.add_exn ~key:MODERNIZATION ~data: (build_int_pair_table upgrade_costs) *)

  (* let get_cost (tables : t) (table_type : tabletype) (key : int * int) : int =
    5 *)
    (* let open Option.Let_syntax in
    match Map.find_exn tables table_type with
      | IntPairTable ip -> Map.find_exn ip key
      | IntTable i ->
          let (k, _) = key in 
          Map.find_exn i k *)