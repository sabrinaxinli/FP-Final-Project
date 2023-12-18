type outcome = RED_MAJOR_GAIN | RED_MINOR_GAIN | STATUS_QUO | BLUE_MINOR_GAIN | BLUE_MAJOR_GAIN
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