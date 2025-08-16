// do not remove comments from this file
import D "mo:base/Debug";
import Timer "mo:base/Timer";

import MigrationTypes "./types";
import v0_0_0 "./v000_000_000";
import v0_1_0 "./v000_001_000";
import v0_0_0Types "./v000_000_000/types";
import v0_1_0Types "./v000_001_000/types";

module {

  let debug_channel = {
    announce = true;
  };

  public let TimerTool = v0_1_0Types.TimerTool;

  let upgrades = [
    v0_1_0.upgrade,
    // do not forget to add your new migration upgrade method here
  ];

  func getMigrationId(state: MigrationTypes.State): Nat {
    return switch (state) {
      case (#v0_0_0(_)) 0;
      case (#v0_1_0(_)) 1;
      // do not forget to add your new migration id here
      // should be increased by 1 as it will be later used as an index to get upgrade/downgrade methods
    };
  };

  //do not change the signature of this function or class-plus migrations will not work.
  public func migrate(
    prevState: MigrationTypes.State, 
    nextState: MigrationTypes.State, 
    args: MigrationTypes.Args,
    caller: Principal,
    canister: Principal
  ): MigrationTypes.State {

   
    var state = prevState;
     
    var migrationId = getMigrationId(prevState);
    let nextMigrationId = getMigrationId(nextState);

    while (nextMigrationId > migrationId) {
      debug if (debug_channel.announce) D.print("in upgrade while" # debug_show((nextMigrationId, migrationId)));
      let migrate = upgrades[migrationId];
      debug if (debug_channel.announce) D.print("upgrade should have run");
      migrationId := if (nextMigrationId > migrationId) migrationId + 1 else migrationId - 1;

      state := migrate(state, args, caller, canister);
    };

    return state;
  };

  public let migration = {
    initialState = #v0_0_0(#data);
    //update your current state version
    currentStateVersion = #v0_0_1(#id);
    getMigrationId = getMigrationId;
    migrate = migrate;
  };
};