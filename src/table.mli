type outcome = RED_MAJOR_GAIN | RED_MINOR_GAIN | STATUS_QUO | BLUE_MINOR_GAIN | BLUE_MAJOR_GAIN
type advantage = RED_ADVANTAGE | PARITY | BLUE_ADVANTAGE

(* Combat resolution table *)
val resolve_combat : ?roll_dice:(unit -> int) -> int -> int -> int -> outcome

(* Noncombat resolution table *)
val resolve_noncombat : ?roll_dice:(unit -> int) -> advantage -> int -> outcome