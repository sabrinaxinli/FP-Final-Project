open Core

module IntPair = struct
  type t = int * int [@@deriving compare, sexp]
end

module ResolutionTable = Map.Make(IntPair)

type outcome = RED_MAJOR_GAIN | RED_MINOR_GAIN | STATUS_QUO | BLUE_MINOR_GAIN | BLUE_MAJOR_GAIN


