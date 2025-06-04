From Coq Require Export List.
From Coq Require Export ZArith.

(* We define the AST and an interpreter for our Rebeca language. *)

(* Three kinds of variables *)
Inductive var: Set :=
| local: nat -> var
| param: nat -> var
| instance: nat -> var.

Definition val: Set := nat.

(* The store (function from variables to values) *)
Definition store: Set := var -> val.

Definition eq_restr (s t: store) (z: list var): Prop :=
  forall (x: var), In x z -> s x = t x. 

(* Expression and guards are embedded as shallow finitely-based functions *)
Record expr: Set := mkexpr {
  eval: store -> nat;
  evar: list var;
  econd: forall (s t: store), eq_restr s t evar -> eval s = eval t
}.
Record guard: Set := mkguard {
  gval: store -> bool;
  gvar: list var;
  gcond: forall (s t: store), eq_restr s t gvar -> gval s = gval t
}.

(* References are the identifiers of self and other rebecs *)
Record ref: Set := mkref {
  self: nat;
  others: list nat;
}.

(* Statement *)
Inductive statement :=
| skip: statement
| assign: var -> expr -> statement
(* TODO: outgoing call *)
| comp: statement -> statement -> statement
| ite: guard -> statement -> statement -> statement
| while: guard -> statement -> statement.
