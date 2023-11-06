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

open Core

(* Player *)
type Player

(* Game Scenario *)
type ActionCard
type InvestmentCard
type DomesticEventCard
type InternationalEventCard
type StartingCondition
type VictoryCondition

type Scenario = {
    player_decks: (Player * (ActionCard list * InvestmentCard list * DomesticEventCard list)) list;
    international_events: InternationalEventCard list;
    starting_condition: StartingCondition;
    victory_condition: VictoryCondition;
}
