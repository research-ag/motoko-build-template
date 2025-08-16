import {test} "mo:test/async";
import Sample "../src/main";
import ExperimentalCycles "mo:base/ExperimentalCycles";

persistent actor {
  

  public func runTests() : async () {


    // add cycles to deploy your canister
    ExperimentalCycles.add<system>(1_000_000_000_000);

    // deploy your canister
    let myCanister = await Sample.SampleCanister(null);

    await test("test name", func() : async () {
      let res = await myCanister.hello();
      assert res == "world!";
    });
  };
};