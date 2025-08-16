import { PocketIcServer } from '@dfinity/pic';

module.exports = async function (): Promise<void> {
  const pic = await PocketIcServer.start({
    showCanisterLogs: true,
    showRuntimeLogs: true,
  });
  const url = pic.getUrl();

  console.log(`PIC server started at ${url}`);

  process.env.PIC_URL = url;
  global.__PIC__ = pic;
};