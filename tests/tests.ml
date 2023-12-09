open OUnit2
open Country
open Core

let test_parameters_1 = {
  force_size = 5;
  national_tech_level = 3;
  resources = 6;
  per_turn_resources = 2;
  influence_points = 0;
}

let test_param_str_1 = {|{
  "force_size": 5,
  "national_tech_level": 3,
  "resources": 6,
  "per_turn_resources": 2,
  "influence_points": 0
}|}

let test_parameters_2 = {
  force_size = 29;
  national_tech_level = 3;
  resources = 0;
  per_turn_resources = 5;
  influence_points = 3;
}

let test_param_str_2 = {|
{
  "force_size": 29,
  "national_tech_level": 3,
  "resources": 0,
  "per_turn_resources": 5,
  "influence_points": 3
}|}

let test_cc_1 = {
  lrf = 5;
  c4isr = 3;
  iamd_bmd = 3;
  sof = 2;
  nuclear_forces = 1;
}

let test_cc_str_1 = {|
  {
    "lrf": 5,
    "c4isr": 3,
    "iamd_bmd": 3,
    "sof": 2,
    "nuclear_forces": 1
  }
|}

let test_cc_2 = {
  lrf = 13;
  c4isr = 0;
  iamd_bmd = 0;
  sof = 23;
  nuclear_forces = 0;
}

let test_cc_str_2 = {|
  {
    "lrf": 13,
    "c4isr": 0,
    "iamd_bmd": 0,
    "sof": 23,
    "nuclear_forces": 0
  }
|}

let aor_json_str_1 = {|
{
  "CONUS": 100,
  "INDOPACOM_PRC": 200,
  "INDOPACOM_DPRK": 300,
  "CENTCOM_IRAN": 400,
  "CENTCOM_AFGHANISTAN": 500,
  "CENTCOM_IRAQ": 600,
  "EUCOM_RU": 700
}
|}

let aor_map_correct_str_1 = {|{"CONUS":100,"INDOPACOM_PRC":200,"INDOPACOM_DPRK":300,"CENTCOM_IRAN":400,"CENTCOM_AFGHANISTAN":500,"CENTCOM_IRAQ":600,"EUCOM_RU":700}|}

let aor_json_str_2 = {|
{
  "CONUS": 0,
  "INDOPACOM_PRC": 0,
  "INDOPACOM_DPRK": 0,
  "CENTCOM_IRAN": 0,
  "CENTCOM_AFGHANISTAN": 0,
  "CENTCOM_IRAQ": 0,
  "EUCOM_RU": 0
}
|}

let aor_map_correct_str_2 = {|{"CONUS":0,"INDOPACOM_PRC":0,"INDOPACOM_DPRK":0,"CENTCOM_IRAN":0,"CENTCOM_AFGHANISTAN":0,"CENTCOM_IRAQ":0,"EUCOM_RU":0}|}

let combat_resource_str_1 = {|
  {
    critical_capabilities: {
      "lrf": 5,
      "c4isr": 3,
      "iamd_bmd": 3,
      "sof": 2,
      "nuclear_forces": 1
    },
    forces: {
      "CONUS": 100,
      "INDOPACOM_PRC": 200,
      "INDOPACOM_DPRK": 300,
      "CENTCOM_IRAN": 400,
      "CENTCOM_AFGHANISTAN": 500,
      "CENTCOM_IRAQ": 600,
      "EUCOM_RU": 700
    }
  }
|}

let combat_resource_str_1_correct = {|{"critical_capabilities":{"lrf":5,"c4isr":3,"iamd_bmd":3,"sof":2,"nuclear_forces":1},"forces":{"CONUS":100,"INDOPACOM_PRC":200,"INDOPACOM_DPRK":300,"CENTCOM_IRAN":400,"CENTCOM_AFGHANISTAN":500,"CENTCOM_IRAQ":600,"EUCOM_RU":700}}|}

let combat_resource_str_2 = {|
  {
    critical_capabilities: {
      "lrf": 13,
      "c4isr": 2,
      "iamd_bmd": 0,
      "sof": 2,
      "nuclear_forces": 0
    },
    forces: {
      "CONUS": 130,
      "INDOPACOM_PRC": 223,
      "INDOPACOM_DPRK": 301,
      "CENTCOM_IRAN": 140,
      "CENTCOM_AFGHANISTAN": 351,
      "CENTCOM_IRAQ": 211,
      "EUCOM_RU": 101
    }
  }
|}

let combat_resource_str_2_correct = {|{"critical_capabilities":{"lrf":13,"c4isr":2,"iamd_bmd":0,"sof":2,"nuclear_forces":0},"forces":{"CONUS":130,"INDOPACOM_PRC":223,"INDOPACOM_DPRK":301,"CENTCOM_IRAN":140,"CENTCOM_AFGHANISTAN":351,"CENTCOM_IRAQ":211,"EUCOM_RU":101}}|}

let country_str_1 = {|
  {
    name: "US",
    parameters: {
      "force_size": 5,
      "national_tech_level": 3,
      "resources": 6,
      "per_turn_resources": 2,
      "influence_points": 0
    },
    combat_resources: {
      critical_capabilities: {
        "lrf": 5,
        "c4isr": 3,
        "iamd_bmd": 3,
        "sof": 2,
        "nuclear_forces": 1
      },
      forces: {
        "CONUS": 100,
        "INDOPACOM_PRC": 200,
        "INDOPACOM_DPRK": 300,
        "CENTCOM_IRAN": 400,
        "CENTCOM_AFGHANISTAN": 500,
        "CENTCOM_IRAQ": 600,
        "EUCOM_RU": 700
      }
    },
    npc: false,
    affiliation: "blue"
  }
|}

let country_str_1_correct = {|{"name":"US","parameters":{"force_size":5,"national_tech_level":3,"resources":6,"per_turn_resources":2,"influence_points":0},"combat_resources":{"critical_capabilities":{"lrf":5,"c4isr":3,"iamd_bmd":3,"sof":2,"nuclear_forces":1},"forces":{"CONUS":100,"INDOPACOM_PRC":200,"INDOPACOM_DPRK":300,"CENTCOM_IRAN":400,"CENTCOM_AFGHANISTAN":500,"CENTCOM_IRAQ":600,"EUCOM_RU":700}},"npc":false,"affiliation":"blue"}|}

let country_str_2 = {|
  {
    name: "US",
    parameters: {
      "force_size": 3,
      "national_tech_level": 1,
      "resources": 5,
      "per_turn_resources": 9,
      "influence_points": 8
    },
    combat_resources: {
      critical_capabilities: {
        "lrf": 13,
        "c4isr": 2,
        "iamd_bmd": 10,
        "sof": 5,
        "nuclear_forces": 3
      },
      forces: {
        "CONUS": 50,
        "INDOPACOM_PRC": 100,
        "INDOPACOM_DPRK": 250,
        "CENTCOM_IRAN": 80,
        "CENTCOM_AFGHANISTAN": 200,
        "CENTCOM_IRAQ": 60,
        "EUCOM_RU": 70
      }
    },
    npc: true,
    affiliation: "red"
  }
|}

let country_str_2_correct = {|{"name":"US","parameters":{"force_size":3,"national_tech_level":1,"resources":5,"per_turn_resources":9,"influence_points":8},"combat_resources":{"critical_capabilities":{"lrf":13,"c4isr":2,"iamd_bmd":10,"sof":5,"nuclear_forces":3},"forces":{"CONUS":50,"INDOPACOM_PRC":100,"INDOPACOM_DPRK":250,"CENTCOM_IRAN":80,"CENTCOM_AFGHANISTAN":200,"CENTCOM_IRAQ":60,"EUCOM_RU":70}},"npc":true,"affiliation":"red"}|}

let run_serialize _ =
  Yojson.Safe.to_file "critical_capabilities.json" (Country.critical_capabilities_to_yojson test_cc_1)


let test_serialize_deserialize_parameters_1 _ = 
  let result_json = Country.parameters_to_yojson test_parameters_1 in
  assert_equal result_json (Yojson.Safe.from_string test_param_str_1)

let test_serialize_deserialize_parameters_2 _ = 
  let result_json = Country.parameters_to_yojson test_parameters_2 in
  assert_equal result_json (Yojson.Safe.from_string test_param_str_2)

let test_serialize_deserialize_cc_1 _ = 
  let result_json = Country.critical_capabilities_to_yojson test_cc_1 in
  assert_equal result_json (Yojson.Safe.from_string test_cc_str_1)

let test_serialize_deserialize_cc_2 _ = 
  let result_json = Country.critical_capabilities_to_yojson test_cc_2 in
  assert_equal result_json (Yojson.Safe.from_string test_cc_str_2)

let test_area_key_of_to_string_valid_CONUS _ =
  let akey = Country.AreaKey.of_string "CONUS" in
  let result_str = Country.AreaKey.to_string akey in
  assert_equal result_str "CONUS"

let test_area_key_of_to_string_valid_INDOPACOM_PRC _ =
  let akey = Country.AreaKey.of_string "INDOPACOM_PRC" in
  let result_str = Country.AreaKey.to_string akey in
  assert_equal result_str "INDOPACOM_PRC"

let test_area_key_of_to_string_valid_INDOPACOM_DPRK _ =
  let akey = Country.AreaKey.of_string "INDOPACOM_DPRK" in
  let result_str = Country.AreaKey.to_string akey in
  assert_equal result_str "INDOPACOM_DPRK"

let test_area_key_of_to_string_valid_CENTCOM_IRAN _ =
  let akey = Country.AreaKey.of_string "CENTCOM_IRAN" in
  let result_str = Country.AreaKey.to_string akey in
  assert_equal result_str "CENTCOM_IRAN"

let test_area_key_of_to_string_valid_CENTCOM_AFGHANISTAN _ =
  let akey = Country.AreaKey.of_string "CENTCOM_AFGHANISTAN" in
  let result_str = Country.AreaKey.to_string akey in
  assert_equal result_str "CENTCOM_AFGHANISTAN"

let test_area_key_of_to_string_valid_CENTCOM_IRAQ _ =
  let akey = Country.AreaKey.of_string "CENTCOM_IRAQ" in
  let result_str = Country.AreaKey.to_string akey in
  assert_equal result_str "CENTCOM_IRAQ"

let test_area_key_of_to_string_valid_EUCOM_RU _ =
  let akey = Country.AreaKey.of_string "EUCOM_RU" in
  let result_str = Country.AreaKey.to_string akey in
  assert_equal result_str "EUCOM_RU"

let test_aor_map_to_yojson_1 _ =
  let yojson_str = Yojson.Safe.from_string aor_json_str_1 in
  let aor_obj = Country.aor_map_of_yojson yojson_str in
  match aor_obj with
    | Ok aor_map ->
        let yojs = Country.aor_map_to_yojson aor_map in
        let result_str = Yojson.Safe.to_string yojs in
        assert_equal result_str aor_map_correct_str_1
    | Error _ -> failwith "should not be aor_map"
    
let test_aor_map_to_yojson_2 _ =
  let yojson_str = Yojson.Safe.from_string aor_json_str_2 in
  let aor_obj = Country.aor_map_of_yojson yojson_str in
  match aor_obj with
    | Ok aor_map ->
        let yojs = Country.aor_map_to_yojson aor_map in
        let result_str = Yojson.Safe.to_string yojs in
        assert_equal result_str aor_map_correct_str_2
    | Error _ -> failwith "should not be aor_map"

let test_combat_resources_of_to_yojson_1 _ =
  let yojson_str = Yojson.Safe.from_string combat_resource_str_1 in
  let combat_resource_result = Country.combat_resources_of_yojson yojson_str in
  match combat_resource_result with
    | Ok combat_resource ->
        let yojson = Country.combat_resources_to_yojson combat_resource in
        let result_str = Yojson.Safe.to_string yojson in
        assert_equal result_str combat_resource_str_1_correct
    | Error _ -> failwith "should not be aor_map"

let test_combat_resources_of_to_yojson_2 _ =
  let yojson_str = Yojson.Safe.from_string combat_resource_str_2 in
  let combat_resource_result = Country.combat_resources_of_yojson yojson_str in
  match combat_resource_result with
    | Ok combat_resource ->
        let yojson = Country.combat_resources_to_yojson combat_resource in
        let result_str = Yojson.Safe.to_string yojson in
        assert_equal result_str combat_resource_str_2_correct
    | Error _ -> failwith "should not be aor_map"

let test_country_of_to_yojson_1 _ =
  let yojson_str = Yojson.Safe.from_string country_str_1 in
  let combat_resource_result = Country.country_data_of_yojson yojson_str in
  match combat_resource_result with
    | Ok combat_resource ->
        let yojson = Country.country_data_to_yojson combat_resource in
        let result_str = Yojson.Safe.to_string yojson in
        assert_equal result_str country_str_1_correct
    | Error _ -> failwith "should not be aor_map"

let test_country_of_to_yojson_2 _ =
  let yojson_str = Yojson.Safe.from_string country_str_2 in
  let combat_resource_result = Country.country_data_of_yojson yojson_str in
  match combat_resource_result with
    | Ok combat_resource ->
        let yojson = Country.country_data_to_yojson combat_resource in
        let result_str = Yojson.Safe.to_string yojson in
        print_endline result_str;
        assert_equal result_str country_str_2_correct
    | Error _ -> failwith "should not be aor_map"

let country_tests =
  "Country tests" 
  >::: [
    (* "setup" >:: test_setup; *)
    "run serialize" >:: run_serialize;
    "test serialize/deserialize params 1" >:: test_serialize_deserialize_parameters_1;
    "test serialize/deserialize params 2" >:: test_serialize_deserialize_parameters_2;
    "test serialize/deserialize cc 1" >:: test_serialize_deserialize_cc_1;
    "test serialize/deserialize cc 2" >:: test_serialize_deserialize_cc_2;
    "test area_key of / to string valid - CONUS" >:: test_area_key_of_to_string_valid_CONUS;
    "test area_key of / to string valid - INDOPACOM_PRC" >:: test_area_key_of_to_string_valid_INDOPACOM_PRC;
    "test area_key of / to string valid - INDOPACOM_DPRK" >:: test_area_key_of_to_string_valid_INDOPACOM_DPRK;
    "test area_key of / to string valid - CENTCOM_IRAN" >:: test_area_key_of_to_string_valid_CENTCOM_IRAN;
    "test area_key of / to string valid - CENTCOM_AFGHANISTAN" >:: test_area_key_of_to_string_valid_CENTCOM_AFGHANISTAN;
    "test area_key of / to string valid - CENTOCOM_IRAQ" >:: test_area_key_of_to_string_valid_CENTCOM_IRAQ;
    "test area_key of / to string valid - EUCOM_RU" >:: test_area_key_of_to_string_valid_EUCOM_RU;
    "test aor_map_to_yojson_1" >:: test_aor_map_to_yojson_1;
    "test aor_map_to_yojson_2" >:: test_aor_map_to_yojson_2;
    "test combat_resources of_to yojson 1" >:: test_combat_resources_of_to_yojson_1;
    "test combat_resources of_to yojson 2" >:: test_combat_resources_of_to_yojson_2;
    "test country of_to yojson 1" >:: test_country_of_to_yojson_1;
    "test country of_to yojson 2" >:: test_country_of_to_yojson_2;
  ]

let all_tests = "Command Converse Tests " >::: [country_tests]
let () =
  run_test_tt_main all_tests