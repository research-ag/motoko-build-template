// This file is an example canister that uses the library for this project. It is an example of how to expose the functionality of the class module to the outside world.
// It is not a complete canister and should not be used as such. It is only an example of how to use the library for this project.


import List "mo:core/List";
import D "mo:core/Debug";
import Int "mo:core/Int";
import Nat "mo:core/Nat";
import Principal "mo:core/Principal";
import Time "mo:core/Time";
import Error "mo:core/Error";
import ClassPlus "mo:class-plus";
import TT "mo:timer-tool";
import ICRC10 "mo:icrc10-mo";
import Log "mo:stable-local-log";

import Sample ".";

shared (deployer) persistent actor class SampleCanister<system>(
  args:?{
    sampleArgs: ?Sample.InitArgs;
    ttArgs: ?TT.InitArgList;
  }
) = this {

  

  transient let thisPrincipal = Principal.fromActor(this);
  var _owner = deployer.caller;

  transient let initManager = ClassPlus.ClassPlusInitializationManager(_owner, Principal.fromActor(this), true);
  transient let sampleInitArgs = do?{args!.sampleArgs!};
  transient let ttInitArgs : ?TT.InitArgList = do?{args!.ttArgs!};

  var icrc10 = ICRC10.initCollection();

  private func reportTTExecution(execInfo: TT.ExecutionReport): Bool{
    D.print("CANISTER: TimerTool Execution: " # debug_show(execInfo));
    return false;
  };

  private func reportTTError(errInfo: TT.ErrorReport) : ?Nat{
    D.print("CANISTER: TimerTool Error: " # debug_show(errInfo));
    return null;
  };

  var tt_migration_state: TT.State = TT.Migration.migration.initialState;

  transient let tt  = TT.Init<system>({
    manager = initManager;
    initialState = tt_migration_state;
    args = ttInitArgs;
    pullEnvironment = ?(func() : TT.Environment {
      {      
        advanced = null;
        reportExecution = ?reportTTExecution;
        reportError = ?reportTTError;
        syncUnsafe = null;
        reportBatch = null;
      };
    });

    onInitialize = ?(func (newClass: TT.TimerTool) : async* () {
      D.print("Initializing TimerTool");
      newClass.initialize<system>();
      //do any work here necessary for initialization
    });
    onStorageChange = func(state: TT.State) {
      tt_migration_state := state;
    }
  });

  var localLog_migration_state: Log.State = Log.initialState();
  transient let localLog = Log.Init<system>({
    args = ?{
      min_level = ?#Debug;
      bufferSize = ?5000;
    };
    manager = initManager;
    initialState = Log.initialState();
    pullEnvironment = ?(func() : Log.Environment {
      {
        tt = tt();
        advanced = null; // Add any advanced options if needed
        onEvict = null;
      };
    });
    onInitialize = null;
    onStorageChange = func(state: Log.State) {
      localLog_migration_state := state;
    };
  });

  transient let d = localLog().log_debug;

  var sample_migration_state: Sample.State = Sample.initialState();

  transient let sample = Sample.Init<system>({
    manager = initManager;
    initialState = sample_migration_state;
    args = sampleInitArgs;
    pullEnvironment = ?(func() : Sample.Environment {
      {
        tt = tt();
        advanced = null; // Add any advanced options if needed
        log = localLog();
      };
    });

    onInitialize = ?(func (newClass: Sample.
    Sample) : async* () {
      D.print("Initializing Sample Class");
      //do any work here necessary for initialization
    });

    onStorageChange = func(state: Sample.State) {
      sample_migration_state := state;
    }
  });


  public shared func hello(): async Text {
    return "world!";
  }


};
