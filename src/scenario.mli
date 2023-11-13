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

(* Game Scenario *)
type action_card = {
    title: string;
    description: string;
    play_cost: int;
    card_number: int;
}
type action_card_deck = action_card list

type investment_card = {
    title: string;
    description: string;
    public: bool;
    play_cost: int;
    card_number: int;
}
type investment_card_deck = investment_card list

type domestic_event_card = {
    title: string;
    description: string;
    public: bool;
    card_number: int;
}
type domestic_event_card_deck = domestic_event_card list

type aor = NORTH | SOUTH | EU | AFRI | CENT | INDOPAC
type international_event_card = {
    title: string;
    description: string;
    aor: aor;
    public: bool;
    card_number: int;
}
type international_event_card_deck = international_event_card list

type starting_condition
type victory_condition

module type Scenario = sig
    type t

    val player_decks : t -> (action_card_deck * investment_card_deck * domestic_event_card_deck) list;
    val international_events : t -> international_event_card_deck;
    val starting_condition : t -> starting_condition;
    val victory_condition : t -> victory_condition;
end

module MakeScenario() : Scenario









