// do not remove comments from this file
import Time "mo:base/Time";
import Principal "mo:base/Principal";
import OVSFixed "mo:ovs-fixed";
import TimerToolLib "mo:timer-tool";
import LogLib "mo:stable-local-log";

// please do not import any types from your project outside migrations folder here
// it can lead to bugs when you change those types later, because migration types should not be changed
// you should also avoid importing these types anywhere in your project directly from here
// use MigrationTypes.Current property instead


module {

  // do not remove the timer tool as it is essential for icrc85
  public let TimerTool = TimerToolLib;
  public let Log = LogLib;


  public type InitArgs = {};

  // do not remove ICRC85 as it is essential for funding open source projects
  public type ICRC85Options = OVSFixed.ICRC85Environment;

  // you may add to this environment, but do not remove tt or advanced.icrc85
  public type Environment = {
    tt: TimerToolLib.TimerTool;
    advanced : ?{
      icrc85 : ICRC85Options;
    };
    log: Log.Local_log;
  };

  //do not remove the tt or icrc85 from this type
  public type Stats = {
    tt: TimerToolLib.Stats;
    icrc85: {
      nextCycleActionId: ?Nat;
      lastActionReported: ?Nat;
      activeActions: Nat;
    };
    log: [Text];
  };

  ///MARK: State
  // do not remove the tt or icrc85 from this type
  public type State = {
    icrc85: {
      var nextCycleActionId: ?Nat;
      var lastActionReported: ?Nat;
      var activeActions: Nat;
    };
  };
};