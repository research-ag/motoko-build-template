import {test; expect; testsys;} "mo:test/async";


import Sample "../src"


await test("sample test", func() : async() {

  

  let result = Sample.test();
  expect.nat(result).equal(1); // Assuming the test method returns 0 for success


});