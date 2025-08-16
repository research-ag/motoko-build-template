import { Principal } from "@dfinity/principal";

import { IDL } from "@dfinity/candid";

import {
  PocketIc,
  createIdentity
} from "@dfinity/pic";

import type {
  Actor,
  CanisterFixture
} from "@dfinity/pic";



// Runtime import: include the .js extension
import { idlFactory as mainIDLFactory, init as mainInit } from "../../src/declarations/main/main.did.js";

// Type-only import: import types from the candid interface without the extension
import type { _SERVICE as mainService } from "../../src/declarations/main/main.did";
  
export const WASM_PATH = ".dfx/local/canisters/main/main.wasm";

let replacer = (_key: any, value: any) => typeof value === "bigint" ? value.toString() + "n" : value;
export const sub_WASM_PATH = process.env['SUB_WASM_PATH'] || WASM_PATH; 
let pic: PocketIc;

let main_fixture: CanisterFixture<mainService>;

const admin = createIdentity("admin");

/*only used when you need NNS state
const NNS_SUBNET_ID =
  "erfz5-i2fgp-76zf7-idtca-yam6s-reegs-x5a3a-nku2r-uqnwl-5g7cy-tqe";
const NNS_STATE_PATH = "pic/nns_state/node-100/state";
*/

describe("test main", () => {
  beforeEach(async () => {
    pic = await PocketIc.create(process.env.PIC_URL, {
      
      /* nns: {
        state: {
          type: SubnetStateType.FromPath,
          path: NNS_STATE_PATH,
          subnetId: Principal.fromText(NNS_SUBNET_ID),
        }
      }, */

      processingTimeoutMs: 1000 * 60 * 5,
    } );

    //const subnets = pic.getApplicationSubnets();

    main_fixture = await pic.setupCanister<mainService>({
      //targetCanisterId: Principal.fromText("q26le-iqaaa-aaaam-actsa-cai"),
      sender: admin.getPrincipal(),
      idlFactory: mainIDLFactory,
      wasm: sub_WASM_PATH,
      //targetSubnetId: subnets[0].id,
      arg: IDL.encode(mainInit({IDL}), [[]]),
    });

  });


  afterEach(async () => {
    await pic.tearDown();
  });



  it('can call hello world', async () => {

    main_fixture.actor.setIdentity(admin);

    const response = await main_fixture.actor.hello();


    console.log("got", response);

    expect(response).toEqual("world!");
  });



});
