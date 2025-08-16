// This file is the main file where your module's code should be implemented. It should contain the main logic of your module and the public functions that will be exposed to other modules or canisters. The file should also include any necessary imports and type definitions.
// Types for this library should be properly filed in the /migrations folder according to the version of the library. The types should be organized in a way that makes it easy to understand and maintain the code.  Do not define new types in this file.

import MigrationTypes "migrations/types";
import MigrationLib "migrations";
import ClassPlusLib "mo:class-plus";
import Buffer "mo:base/Buffer";
import Service "service";
import D "mo:base/Debug";
import Star "mo:star/star";
import ovsfixed "mo:ovs-fixed";
import Int "mo:base/Int";
import Time "mo:base/Time";
import Error "mo:base/Error";
import Principal "mo:base/Principal";
import Blob "mo:base/Blob";
import Nat "mo:base/Nat";
import Timer "mo:base/Timer";
import Map "mo:map/Map";
import Log "mo:stable-local-log";

module {

  public let Migration = MigrationLib;
  public let TT = MigrationLib.TimerTool;
  public type State = MigrationTypes.State;
  public type CurrentState = MigrationTypes.Current.State;
  public type Environment = MigrationTypes.Current.Environment;
  public type Stats = MigrationTypes.Current.Stats;
  public type InitArgs = MigrationTypes.Current.InitArgs;

  public let init = Migration.migrate;

  public func initialState() : State {#v0_0_0(#data)};
  public let currentStateVersion = #v0_1_0(#id);


  public func test() : Nat{
    1;
  };

  public func natNow() : Nat{
    Int.abs(Time.now());
  };

  public let ICRC85_Timer_Namespace = "icrc85:ovs:shareaction:sample";
  public let ICRC85_Payment_Namespace = "com.sample-org.libraries.sample";

  public func Init<system>(config : {
    manager: ClassPlusLib.ClassPlusInitializationManager;
    initialState: State;
    args : ?InitArgs;
    pullEnvironment : ?(() -> Environment);
    onInitialize: ?(Sample -> async*());
    onStorageChange : ((State) ->())
  }) :()-> Sample {

    let instance = ClassPlusLib.ClassPlus<system,
      Sample, 
      State,
      InitArgs,
      Environment>({config with constructor = Sample}).get;
    
    ovsfixed.initialize_cycleShare<system>({
      namespace = ICRC85_Timer_Namespace;
      icrc_85_state = instance().state.icrc85;
      wait = null;
      registerExecutionListenerAsync = instance().environment.tt.registerExecutionListenerAsync;
      setActionSync = instance().environment.tt.setActionSync;  
      existingIndex = instance().environment.tt.getState().actionIdIndex;
      handler = instance().handleIcrc85Action;
    });

    instance;
  };

  public class Sample(stored: ?State, instantiator: Principal, canister: Principal, args: ?InitArgs, environment_passed: ?Environment, storageChanged: (State) -> ()){

    public let debug_channel = {
      var announce = true;
    };

    public let environment = switch(environment_passed){
      case(?val) val;
      case(null) {
        D.trap("Environment is required");
      };
    };

    let d = environment.log.log_debug;

    public var state : CurrentState = switch(stored){
      case(null) {
        let #v0_1_0(#data(foundState)) = init(initialState(),currentStateVersion, null, instantiator, canister);
        foundState;
      };
      case(?val) {
        let #v0_1_0(#data(foundState)) = init(val, currentStateVersion, null, instantiator, canister);
        foundState;
      };
    };

    storageChanged(#v0_1_0(#data(state)));

    let self : Service.Service = actor(Principal.toText(canister));


    ///////////
    // ICRC85 ovs
    //////////

    public func handleIcrc85Action<system>(id: TT.ActionId, action: TT.Action) : async* Star.Star<TT.ActionId, TT.Error> {
      switch (action.actionType) {
        case (ICRC85_Timer_Namespace) {
          await* ovsfixed.standardShareCycles({
            icrc_85_state = state.icrc85;
            icrc_85_environment = do?{environment.advanced!.icrc85!};
            setActionSync = environment.tt.setActionSync;
            timerNamespace = ICRC85_Timer_Namespace;
            paymentNamespace = ICRC85_Payment_Namespace;
            baseCycles = 1_000_000_000_000; // 1 XDR
            maxCycles = 100_000_000_000_000; // 1 XDR
            actionDivisor = 10000;
            actionMultiplier = 200_000_000_000; // .2 XDR
          });
          #awaited(id);
        };
        case (_) #trappable(id);
      };
    };

  };

};