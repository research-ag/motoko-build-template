// do not remove comments from this file
import MigrationTypes "../types";
import Time "mo:base/Time";
import v0_1_0 "types";
import D "mo:base/Debug";

module {

  //do not change the signature of this function or class-plus migrations will not work.
  public func upgrade(prevmigration_state: MigrationTypes.State, args: MigrationTypes.Args, caller: Principal, canister: Principal): MigrationTypes.State {

    /*
    todo: implement init args
    let (previousEventIDs,
      pendingEvents) = switch (args) {
      case (?args) {
        switch(args.restore){
          case(?restore){
            let existingPrevIds = BTree.
            (restore.)
          }
        }
      };
      case (_) {("nobody")};
    };
    */

    // You must output the same type that is defined in the types.mo file in this directory.
    let state : v0_1_0.State = {
      icrc85 = {
        var nextCycleActionId: ?Nat = null; // Initialize to null or a specific value if needed
        var lastActionReported: ?Nat = null; // Initialize to null or a specific value if needed
        var activeActions: Nat = 0; // Initialize to 0 or a specific value if needed
      };

    };

    return #v0_1_0(#data(state));
  };
};