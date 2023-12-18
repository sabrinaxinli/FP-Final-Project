open OUnit2
open Table

let test_resolve_combat_blue_adv _ =
  (* > 4:1 *)
  assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 15);
  assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 5 1 4);
  assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 5 1 3);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 5 1 2);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 5 1 1);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 5 1 0);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 5 1 (-1));
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 5 1 (-2));
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 5 1 (-3));
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 5 1 (-4));
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 5 1 (-5));
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 5 1 (-6));

  (* 4:1 *)
  assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 15);
  assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 1 4);
  assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 1 3);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 1 2);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 1 1);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 1 0);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 1 (-1));
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 1 (-2));
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 1 (-3));
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 4 1 (-4));
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 4 1 (-5));
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 4 1 (-6));

  (* 3:1 *)
  assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 15);
  assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 7);
  assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 6);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 5);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 4);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 3);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 2);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 1);
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 0);
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 (-1));
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 (-2));
  assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 (-3));
  assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 (-4));
  assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 (-5));
  assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 3 1 (-6));

  (* 2:1 *)
  assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 15);
  assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 9);
  assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 8);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 7);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 6);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 5);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 4);
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 3);
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 2);
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 1);
  assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 0);
  assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 (-1));
  assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 (-2));
  assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 (-3));
  assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 (-4));
  assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 1 (-6))

let test_resolve_combat_parity _ =
  assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 4 15);
  assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 4 10);
  assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 4 9);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 4 8);
  assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 4 7);
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 4 4 6);
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 4 4 5);
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 4 4 4);
  assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 4 4 3);
  assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 4 2);
  assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 4 1);
  assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 4 0);
  assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 4 (-1));
  assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 4 4 (-6))

  let test_resolve_combat_red_adv _ =
    (* 2:1 *)
    assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 15);
    assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 13);
    assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 12);
    assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 11);
    assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 10);
    assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 9);
    assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 8);
    assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 7);
    assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 6);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 5);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 4);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 3);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 2);
    assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 1);
    assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 0);
    assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 4 (-6));

    (* 3:1 *)
    assert_equal BLUE_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 6 15);
    assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 6 14);
    assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 6 13);
    assert_equal BLUE_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 6 12);
    assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 2 6 11);
    assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 2 6 10);
    assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 2 6 9);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 6 8);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 6 7);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 6 6);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 6 5);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 6 4);
    assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 6 3);
    assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 6 2);
    assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 6 (-6));

    (* 4:1 *)
    assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 2 8 15);
    assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 2 8 14);
    assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 2 8 13);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 8 12);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 8 11);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 8 10);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 8 9);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 8 8);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 8 7);
    assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 8 6);
    assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 8 5);
    assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 8 (-6));

    (* > 4:1 *)
    assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 2 10 15);
    assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 2 10 14);
    assert_equal STATUS_QUO (resolve_combat ~roll_dice:(fun _ -> 0) 2 10 13);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 10 12);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 10 11);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 10 10);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 10 9);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 10 8);
    assert_equal RED_MINOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 10 7);
    assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 10 6);
    assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 10 5);
    assert_equal RED_MAJOR_GAIN (resolve_combat ~roll_dice:(fun _ -> 0) 2 10 (-6))
  
let test_resolve_noncombat _ =
  (* Test BLUE_ADVANTAGE cases *)
  assert_equal BLUE_MAJOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) BLUE_ADVANTAGE 9);
  assert_equal BLUE_MAJOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) BLUE_ADVANTAGE 10);
  assert_equal BLUE_MINOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) BLUE_ADVANTAGE 5);
  assert_equal BLUE_MINOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) BLUE_ADVANTAGE 8);
  assert_equal STATUS_QUO (resolve_noncombat ~roll_dice:(fun _ -> 0) BLUE_ADVANTAGE 1);
  assert_equal STATUS_QUO (resolve_noncombat ~roll_dice:(fun _ -> 0) BLUE_ADVANTAGE 4);
  assert_equal RED_MINOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) BLUE_ADVANTAGE 0);

  (* Test PARITY cases *)
  assert_equal BLUE_MAJOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) PARITY 12);
  assert_equal BLUE_MAJOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) PARITY 13);
  assert_equal BLUE_MINOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) PARITY 7);
  assert_equal BLUE_MINOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) PARITY 11);
  assert_equal STATUS_QUO (resolve_noncombat ~roll_dice:(fun _ -> 0) PARITY 3);
  assert_equal STATUS_QUO (resolve_noncombat ~roll_dice:(fun _ -> 0) PARITY 6);
  assert_equal RED_MINOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) PARITY 2);
  assert_equal RED_MINOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) PARITY (-2));
  assert_equal RED_MAJOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) PARITY (-3));

  (* Test RED_ADVANTAGE cases *)
  assert_equal BLUE_MINOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) RED_ADVANTAGE 9);
  assert_equal BLUE_MINOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) RED_ADVANTAGE 10);
  assert_equal STATUS_QUO (resolve_noncombat ~roll_dice:(fun _ -> 0) RED_ADVANTAGE 5);
  assert_equal STATUS_QUO (resolve_noncombat ~roll_dice:(fun _ -> 0) RED_ADVANTAGE 8);
  assert_equal RED_MINOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) RED_ADVANTAGE 1);
  assert_equal RED_MINOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) RED_ADVANTAGE 4);
  assert_equal RED_MAJOR_GAIN (resolve_noncombat ~roll_dice:(fun _ -> 0) RED_ADVANTAGE 0)

let suite =
  "Resolution Table Tests" >:::
  [
    "Resolve Combat Tests" >::: [
      "Blue Advantage" >:: test_resolve_combat_blue_adv;
      "Parity" >:: test_resolve_combat_parity;
      "Red Advantage" >:: test_resolve_combat_red_adv;
    ];
    "test_resolve_noncombat" >:: test_resolve_noncombat;
  ]

let () =
  run_test_tt_main suite