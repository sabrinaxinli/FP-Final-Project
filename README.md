# Command & Converse: Pioneering AI Facilitation in Digital Strategy Games

We are developing a text-based, networked version of the tabletop strategy
game, Hedgemony. Players will connect to a central server, which will manage
and synchronize the game state. Hedgemony is a turn-based, facilitated tabletop
game to teach strategy. Game scenarios will be loaded from conigurable
YAML/JSON files, allowing for a variety of gameplay experiences. The core game
logic and sample client code will be implemented in OCaml. Time-permitting, a
client will be implemented to connect to GPT to demonstrate game play.

Libraries:
- Core
- Lwt / Async - Networking
- ppx_deriving_yojson - Configuration Parsing
- OUnit2 - Testing
- dune / opam - Build and Packaging