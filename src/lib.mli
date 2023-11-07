(*****************************************************************************)
(*                                                                           *)
(* File: lib.mli                                                             *)
(*                                                                           *)
(* Project: Command & Converse                                               *)
(*                                                                           *)
(* Author: Adam Byerly & Sabrina Li                                          *)
(*                                                                           *)
(* Description:                                                              *)
(* This file contains ...                                                    *)
(*                                                                           *)
(*****************************************************************************)

(* Player *)
type player

(* Game Scenario *)
type action_card
type action_card_deck = action_card list

type investment_card
type investment_card_deck = investment_card list

type domestic_event_card
type domestic_event_card_deck = domestic_event_card list

type international_event_card
type international_event_card_deck = international_event_card list

type starting_condition
type victory_condition

type scenario = {
    player_decks: (player * (action_card_deck * international_event_card_deck * domestic_event_card_deck)) list;
    international_events: international_event_card_deck;
    starting_condition: starting_condition;
    victory_condition: victory_condition;
}
