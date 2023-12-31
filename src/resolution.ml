open Core

module IntPair = struct
  type t = int * int [@@deriving compare, sexp]
end

module IntPairTable = Map.Make(IntPair)

type cost_table = int IntPairTable.t

type tabletype = PROCUREMENT | MODERNIZATION | DEPLOYMENT | COMBAT_FACTORS [@@deriving compare, sexp]

type outcome = RED_MAJOR_GAIN | RED_MINOR_GAIN | STATUS_QUO | BLUE_MINOR_GAIN | BLUE_MAJOR_GAIN

module TableType = struct
  type t = tabletype
  let t_of_sexp = tabletype_of_sexp
  let sexp_of_t = sexp_of_tabletype
  let compare = compare_tabletype
end

module ResolutionTable = Map.Make(TableType)

type resolution_table = cost_table ResolutionTable.t

module type ActionCost = sig
  type t = resolution_table
  type k = int * int
  val get_table_map: unit -> t
  val get_cost: t -> tabletype -> k -> int option
end

module ActionCostImpl : ActionCost = struct
  type t = resolution_table
  type k = int * int
  let procurement_costs = [
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
    ((10, 1), 10); ((10, 2), 11); ((10, 3), 12); ((10, 4), 13); ((10, 5), 14); ((10, 6), 15)]

  let deploy_costs = [
    ((1, 0), 1); ((1, 1), 2);
    ((2, 0), 1); ((2, 1), 2);
    ((3, 0), 2); ((3, 1), 3);
    ((4, 0), 2); ((4, 1), 3);
    ((5, 0), 3); ((5, 1), 5);
    ((6, 0), 3); ((6, 1), 5);
    ((7, 0), 4); ((7, 1), 6);
    ((8, 0), 4); ((8, 1), 6);
    ((9, 0), 5); ((9, 1), 8);
    ((10, 0), 5); ((10, 1), 8);
    ((11, 0), 6); ((11, 1), 9);
    ((12, 0), 6); ((12, 1), 9);
    ((13, 0), 7); ((13, 1), 11);
    ((14, 0), 7); ((14, 1), 11);
    ((15, 0), 8); ((15, 1), 12)]

  let combat_factors = [
    ((1, 1), 1); ((1, 2), 2); ((1, 3), 3); ((1, 4), 4); ((1, 5), 5); ((1, 6), 6); ((1, 7), 7);
    ((2, 1), 2); ((2, 2), 3); ((2, 3), 4); ((2, 4), 6); ((2, 5), 7); ((2, 6), 8); ((2, 7), 10);
    ((3, 1), 3); ((3, 2), 4); ((3, 3), 6); ((3, 4), 8); ((3, 5), 10); ((3, 6), 12); ((3, 7), 14);
    ((4, 1), 4); ((4, 2), 6); ((4, 3), 8); ((4, 4), 11); ((4, 5), 13); ((4, 6), 15); ((4, 7), 18);
    ((5, 1), 5); ((5, 2), 7); ((5, 3), 10); ((5, 4), 13); ((5, 5), 16); ((5, 6), 19); ((5, 7), 22);
    ((6, 1), 6); ((6, 2), 9); ((6, 3), 12); ((6, 4), 16); ((6, 5), 19); ((6, 6), 22); ((6, 7), 26);
    ((7, 1), 7); ((7, 2), 10); ((7, 3), 14); ((7, 4), 18); ((7, 5), 22); ((7, 6), 26); ((7, 7), 30);
    ((8, 1), 8); ((8, 2), 12); ((8, 3), 16); ((8, 4), 21); ((8, 5), 25); ((8, 6), 29); ((8, 7), 34);
    ((9, 1), 9); ((9, 2), 13); ((9, 3), 18); ((9, 4), 23); ((9, 5), 28); ((9, 6), 33); ((9, 7), 38);
    ((10, 1), 10); ((10, 2), 15); ((10, 3), 20); ((10, 4), 26); ((10, 5), 31); ((10, 6), 36); ((10, 7), 42);
    ((11, 1), 11); ((11, 2), 16); ((11, 3), 22); ((11, 4), 28); ((11, 5), 34); ((11, 6), 40); ((11, 7), 46);
    ((12, 1), 12); ((12, 2), 18); ((12, 3), 24); ((12, 4), 31); ((12, 5), 37); ((12, 6), 43); ((12, 7), 50);
    ((13, 1), 13); ((13, 2), 19); ((13, 3), 26); ((13, 4), 33); ((13, 5), 40); ((13, 6), 47); ((13, 7), 54);
    ((14, 1), 14); ((14, 2), 21); ((14, 3), 28); ((14, 4), 36); ((14, 5), 43); ((14, 6), 50); ((14, 7), 58);
    ((15, 1), 15); ((15, 2), 22); ((15, 3), 30); ((15, 4), 38); ((15, 5), 46); ((15, 6), 54);((15, 7), 62)]


  let build_int_pair_table (ls : ((int * int) * int) list) : cost_table =
    (List.fold ls ~init:IntPairTable.empty ~f:(fun acc ((ff, mod_level), cost) -> 
      Map.add_exn acc ~key: (ff, mod_level) ~data: cost))

  let get_table_map () : t = 
    ResolutionTable.empty
    |> Map.add_exn ~key:PROCUREMENT ~data: (build_int_pair_table procurement_costs)
    |> Map.add_exn ~key:MODERNIZATION ~data: (build_int_pair_table upgrade_costs)
    |> Map.add_exn ~key:DEPLOYMENT ~data: (build_int_pair_table deploy_costs)
    |> Map.add_exn ~key:COMBAT_FACTORS ~data: (build_int_pair_table combat_factors)

  let get_cost (tables: t) (table_type : tabletype) (key : k) : int option =
    let open Option.Let_syntax in
    Map.find tables table_type >>= (fun x -> Map.find x key)

end

type advantage = RED_ADVANTAGE | PARITY | BLUE_ADVANTAGE

let resolve_combat ?(roll_dice = fun _ -> Random.int 10) (blue_cf : int) (red_cf : int) (modifier : int) : outcome =
  let adv, ratio = 
    if blue_cf = red_cf then (PARITY, 1) 
    else if blue_cf > red_cf then (BLUE_ADVANTAGE, blue_cf / red_cf)
    else (RED_ADVANTAGE, red_cf / blue_cf)
  in 
  let roll = roll_dice () + modifier in
  match adv, ratio, roll with
  | BLUE_ADVANTAGE, n, m when n >= 4 && m >= 3 -> BLUE_MAJOR_GAIN
  | BLUE_ADVANTAGE, n, m when n >= 4 && m <= 2 && m >= -3 -> BLUE_MINOR_GAIN
  | BLUE_ADVANTAGE, n, m when n >= 4 && m <= -4 -> STATUS_QUO
  | BLUE_ADVANTAGE, 3, m when m >= 6 -> BLUE_MAJOR_GAIN
  | BLUE_ADVANTAGE, 3, m when m <= 5 && m >= 1 -> BLUE_MINOR_GAIN
  | BLUE_ADVANTAGE, 3, m when m <= 0 && m >= -2 -> STATUS_QUO
  | BLUE_ADVANTAGE, 3, m when m <= -3 && m >= -5 -> RED_MINOR_GAIN
  | BLUE_ADVANTAGE, 3, m when m <= -6 -> RED_MAJOR_GAIN
  | BLUE_ADVANTAGE, 2, m when m >= 8 -> BLUE_MAJOR_GAIN
  | BLUE_ADVANTAGE, 2, m when m <= 7 && m >= 4 -> BLUE_MINOR_GAIN
  | BLUE_ADVANTAGE, 2, m when m <= 3 && m >= 1 -> STATUS_QUO
  | BLUE_ADVANTAGE, 2, m when m <= 0 && m >= -2 -> RED_MINOR_GAIN
  | BLUE_ADVANTAGE, 2, m when m <= -3 -> RED_MAJOR_GAIN
  | PARITY, 1, m when m >= 9 -> BLUE_MAJOR_GAIN
  | PARITY, 1, m when m <= 8 && m >= 7 -> BLUE_MINOR_GAIN
  | PARITY, 1, m when m <= 6 && m >= 3 -> STATUS_QUO
  | PARITY, 1, m when m <= 2 && m >= 1 -> RED_MINOR_GAIN
  | PARITY, 1, m when m <= 0 -> RED_MAJOR_GAIN
  | RED_ADVANTAGE, 2, m when m >= 12 -> BLUE_MAJOR_GAIN
  | RED_ADVANTAGE, 2, m when m <= 11 && m >= 9 -> BLUE_MINOR_GAIN
  | RED_ADVANTAGE, 2, m when m <= 8 && m >= 6 -> STATUS_QUO
  | RED_ADVANTAGE, 2, m when m <= 5 && m >= 2 -> RED_MINOR_GAIN
  | RED_ADVANTAGE, 2, m when m <= 1 -> RED_MAJOR_GAIN
  | RED_ADVANTAGE, 3, m when m > 14 -> BLUE_MAJOR_GAIN
  | RED_ADVANTAGE, 3, m when m <= 14 && m >= 12 -> BLUE_MINOR_GAIN
  | RED_ADVANTAGE, 3, m when m <= 11 && m >= 9 -> STATUS_QUO
  | RED_ADVANTAGE, 3, m when m <= 8 && m >= 4 -> RED_MINOR_GAIN
  | RED_ADVANTAGE, 3, m when m <= 3 -> RED_MAJOR_GAIN
  | RED_ADVANTAGE, _, m when m >= 13 -> STATUS_QUO
  | RED_ADVANTAGE, _, m when m <= 12 && m >= 7 -> RED_MINOR_GAIN
  | RED_ADVANTAGE, _, m when m <= 6 -> RED_MAJOR_GAIN
  | _ -> failwith "Combat resolution table error - should never reach this state"

let resolve_noncombat ?(roll_dice = fun _ -> Random.int 10) (adv : advantage) (modifier : int) : outcome =
  let roll = roll_dice () + modifier in
  match adv, roll with
  | BLUE_ADVANTAGE, m when m >= 9 -> BLUE_MAJOR_GAIN
  | BLUE_ADVANTAGE, m when m <= 8 && m >= 5 -> BLUE_MINOR_GAIN
  | BLUE_ADVANTAGE, m when m <= 4 && m >= 1 -> STATUS_QUO
  | BLUE_ADVANTAGE, m when m <= 0 -> RED_MINOR_GAIN
  | PARITY, m when m >= 12 -> BLUE_MAJOR_GAIN
  | PARITY, m when m <= 11 && m >= 7 -> BLUE_MINOR_GAIN
  | PARITY, m when m <= 6 && m >= 3 -> STATUS_QUO
  | PARITY, m when m <= 2 && m >= -2 -> RED_MINOR_GAIN
  | PARITY, m when m <= -3 -> RED_MAJOR_GAIN
  | RED_ADVANTAGE, m when m >= 9 -> BLUE_MINOR_GAIN
  | RED_ADVANTAGE, m when m <= 8 && m >= 5 -> STATUS_QUO
  | RED_ADVANTAGE, m when m <= 4 && m >= 1 -> RED_MINOR_GAIN
  | RED_ADVANTAGE, m when m <= 0 -> RED_MAJOR_GAIN
  | _ -> failwith "Noncombat resolution table error - should never reach this state"