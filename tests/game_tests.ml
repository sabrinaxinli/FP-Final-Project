open OUnit2
open Core
open Game
(* Test Data *)
let test_card_1 : card = {
  player = "US";
  card_type = ACTION;
  title = "Test Card";
  description = "This is a Test Card";
  card_number = "US-T1";
  involved = ["US";"PRC"];
  aor = None;
  public = None;
  play_cost = Some 1;
  replayable = true;
}


let test_card_str_1 = {|
  {"player":"US",
  "card_type":["ACTION"],
  "title":"Test Card",
  "description":"This is a Test Card",
  "card_number":"US-T1",
  "involved":["US","PRC"],
  "aor":null,
  "public":null,
  "play_cost":1,
  "replayable":true}
|}

let domestic_card1 = {
  player = "Facilitator";
  card_type = DOMESTIC_EVENT;
  title = "Research Failure (LRF)";
  description = "Problems with rocket motor tests and overly ambitious technical milesetones create problems for China's next generation LRF program. Delays and costs overruns cast doubt on China's ability to move forward in this area.";
  card_number = "EVT-PRC-02";
  involved = ["PRC"];
  aor = Some "INDOPACOM_PRC";
  public = None;
  play_cost = Some 4;
  replayable = true;
}

let international_card1 = {
  player = "Facilitator";
  card_type = INTERNATIONAL_EVENT;
  title = "Conflict Event - India-Pakistani Tensions";
  description = "A dramatic terrorist attack on the Indian Parliament captures global headlines. The attack is traced back to a Pakistani militant group with links to the Directorate of INter-Service Intelligence (ISI). There is continuing combat involving Pakistani ISI-supported groups and INdian military and paramilitary forces in Jammu and Kashmir. This complicates US counter-terrorism (CT) operations in Afghanistan. CHina has an opportunity to support Pakistan.";
  card_number = "EVT-CON-16";
  involved = ["US";"PRC"];
  aor = Some "INDOPACOM_PRC";
  public = Some true;
  play_cost = None;
  replayable = false;
}

(* let test_playerdeck_1 = [prc_card1; prc_card2]

let test_domestic_deck = [domestic_card1]

let test_international_deck = [international_card1] *)

let us_country_str = {|{"name":"US","home_region":"CONUS","parameters":{"modifier":20,"national_tech_level":4,"resources":40,"per_turn_resources":30,"influence_points":50},"critical_capabilities":{"lrf":0,"c4isr":3,"iamd_bmd":3,"sof":3,"nuclear_forces":0},"forces":{"CONUS":[{"force_factor":14,"modernization_level":3,"readiness":10,"pinned":0}],"INDOPACOM_PRC":[{"force_factor":1,"modernization_level":3,"readiness":2,"pinned":0},{"force_factor":1,"modernization_level":3,"readiness":10,"pinned":0}]},"npc":false,"affiliation":["BLUE"]}|}


let prc_country_str = {|{"name":"PRC","home_region":"INDOPACOM_PRC","parameters":{"modifier":15,"national_tech_level":4,"resources":15,"per_turn_resources":4,"influence_points":5},"critical_capabilities":{"lrf":4,"c4isr":3,"iamd_bmd":0,"sof":0,"nuclear_forces":0},"forces":{"INDOPACOM_PRC":[{"force_factor":5,"modernization_level":3,"readiness":10,"pinned":0},{"force_factor":5,"modernization_level":2,"readiness":10,"pinned":0},{"force_factor":5,"modernization_level":1,"readiness":10,"pinned":0}]},"npc":true,"affiliation":["RED"]}|}

(* let test_aor_map_to_yojson_1 _ =
  print_endline "worked";
  let serialized = Country.aor_map_to_yojson aor_map in
  assert_equal serialized (Yojson.Safe.from_string aor_map_1) *)


(* Serialization Tests *)

let test_card_to_of_yojson _ = 
  let result_json = card_to_yojson test_card_1 in
  assert_equal result_json (Yojson.Safe.from_string test_card_str_1);

  let serialized_json = DeckImpl.load_cards "../../../tests/data/domestic_cards.json" in
  assert_equal (Game.equal_card (List.hd_exn serialized_json) domestic_card1) true;

  let serialized_json = DeckImpl.load_cards "../../../tests/data/international_cards.json" in
  assert_equal (Game.equal_card (List.hd_exn serialized_json) international_card1) true


let test_game_data : game_data = Game.GameStateImpl.start_game ~countries_fp:"../../../tests/data/countries.json" ~player_decks_dir:"../../../tests/data/player_decks/" ~domestic_fp:"../../../tests/data/domestic_cards.json" ~int_fp:"../../../tests/data/international_cards.json"

let test_game_data_countries _ =
  assert_equal (List.length (get_current_countries test_game_data.countries)) 2;

  let us = Map.find_exn test_game_data.countries "US" in
  assert_equal (Country.country_data_to_yojson us |> Yojson.Safe.to_string) us_country_str;

  let us = Map.find_exn test_game_data.countries "PRC" in 
  assert_equal (Country.country_data_to_yojson us |> Yojson.Safe.to_string) prc_country_str

(* let test_deserialize_countries _ = 
  let country_list = Country.CountryImpl.create "../../../tests/data/countries.json" in
  print_endline (string_of_int (List.length country_list)) *)

let test_get_size _ = 
  assert_equal (List.length test_game_data.domestic_event_deck) 1

let test_us_playcards_response = Game.PlayCards "US-01"
let test_prc_playcards_response_1 = Game.PlayCards "PRC-01"
let test_prc_playcards_response_2 = Game.PlayCards "PRC-22"
let test_validate_playcards _ = 
  assert_equal (Some 3) (Game.GameStateImpl.validate_action test_game_data "US" test_us_playcards_response);
  assert_equal (Some 3) (Game.GameStateImpl.validate_action test_game_data "PRC" test_prc_playcards_response_1);
  assert_equal (Some 4) (Game.GameStateImpl.validate_action test_game_data "PRC" test_prc_playcards_response_2)
  
let us_force_1 : Country.force = {
  force_factor = 5;
  modernization_level = 3;
  readiness = 10;
  pinned = 0
}

let us_force_2 : Country.force = {
  force_factor = 1;
  modernization_level = 3;
  readiness = 10;
  pinned = 0
}

let us_force_3 : Country.force = {
  force_factor = 1;
  modernization_level = 7;
  readiness = 10;
  pinned = 0
}

let test_procure_response_1 = Game.ProcureForce ("CONUS", us_force_1)
let test_procure_response_2 = Game.ProcureForce ("CONUS", us_force_2)
let test_procure_response_3 = Game.ProcureForce ("CONUS", us_force_3)
let test_validate_procurement _ =
  assert_equal (Some 16) (Game.GameStateImpl.validate_action test_game_data "US" test_procure_response_1);
  assert_equal (Some 4) (Game.GameStateImpl.validate_action test_game_data "US" test_procure_response_2);
  assert_equal None (Game.GameStateImpl.validate_action test_game_data "US" test_procure_response_3)


let test_modernize_response_1 = Game.ModernizeForce ("CONUS", us_force_1, 1) 
let test_modernize_response_2 = Game.ModernizeForce ("INDOPACOM_PRC", us_force_2, 1) 
let test_modernize_response_3 = Game.ModernizeForce ("INDOPACOM_PRC", us_force_2, 2) (* Can't modernize beyond national tech level *)
let test_validate_modernization _ =
  assert_equal (Some 5) (Game.GameStateImpl.validate_action test_game_data "US" test_modernize_response_1);
  assert_equal (Some 1) (Game.GameStateImpl.validate_action test_game_data "US" test_modernize_response_2);
  assert_equal None (Game.GameStateImpl.validate_action test_game_data "US" test_modernize_response_3)

let test_deploy_response_1 = Game.DeployForces ("INDOPACOM_PRC", "CONUS", [us_force_2])
let test_deploy_response_2 = Game.DeployForces ("INDOPACOM_PRC", "CONUS", [us_force_3])
let test_validate_deployment _ =
  assert_equal (Some 1) (Game.GameStateImpl.validate_action test_game_data "US" test_deploy_response_1);
  assert_equal None (Game.GameStateImpl.validate_action test_game_data "US" test_deploy_response_2)

let prc_force_1 : Country.force = {
  force_factor = 5;
  modernization_level = 2;
  readiness = 10;
  pinned = 0
}

let prc_force_2 : Country.force = {
  force_factor = 5;
  modernization_level = 3;
  readiness = 10;
  pinned = 0
}

let fake_prc_force_1 : Country.force = {
  force_factor = 10;
  modernization_level = 3;
  readiness = 10;
  pinned = 0
}

let test_initiate_combat_response_1 = Game.InitiateCombat ("US", "INDOPACOM_PRC", [us_force_2])
let test_initiate_combat_response_2 = Game.InitiateCombat ("PRC", "INDOPACOM_PRC", [prc_force_1; prc_force_2])

let test_initiate_combat_response_3 = Game.InitiateCombat ("PRC", "INDOPACOM_PRC", [fake_prc_force_1])

let test_initiate_combat _ =
  assert_equal (Some 0) (Game.GameStateImpl.validate_action test_game_data "US" test_initiate_combat_response_1);
  assert_equal (Some 0) (Game.GameStateImpl.validate_action test_game_data "PRC" test_initiate_combat_response_2);
  assert_equal None (Game.GameStateImpl.validate_action test_game_data "PRC" test_initiate_combat_response_3)

let to_upgrade : Country.force = {
  force_factor = 1;
  modernization_level = 3;
  readiness = 2;
  pinned  = 0
}

let test_buyback_response_1 = Game.BuybackReadiness ("INDOPACOM_PRC", [to_upgrade], 5)
let test_buyback_response_2 = Game.BuybackReadiness("CONUS", [to_upgrade], 9)

let test_buyback_validation _ =
  assert_equal (Some 8) (Game.GameStateImpl.validate_action test_game_data "US" test_buyback_response_1);
  assert_equal None (Game.GameStateImpl.validate_action test_game_data "US" test_buyback_response_2)


let suite =
  "Card Tests" >:::
  [
    "Yojson Tests" >::: [
      "(De)serialize Cards" >:: test_card_to_of_yojson;
      (* "(De)serialize AOR Map" >:: test_aor_map_to_yojson_1; *)
    ];
    "Gamedata Tests" >::: [
      "Deck size" >:: test_get_size;
      "(De)serialize Countries" >:: test_game_data_countries;
      "Test validate playcards" >:: test_validate_playcards;
      "Test procurement" >:: test_validate_procurement;
      "Test modernization" >:: test_validate_modernization;
      "Test validate deployment" >:: test_validate_deployment;
      "Test combat initiation" >:: test_initiate_combat;
      "Test buyback" >:: test_buyback_validation
    ]
  ]

let () =
  run_test_tt_main suite