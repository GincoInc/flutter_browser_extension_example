import NodeWalletConnect from "@walletconnect/node";
// import WalletConnectQRCodeModal from "@walletconnect/qrcode-modal";

// Create connector
const walletConnector = new NodeWalletConnect(
  {
    bridge: "https://bridge.walletconnect.org", // Required
  },
  {
    clientMeta: {
      description: "WalletConnect NodeJS Client",
      url: "https://nodejs.org/en/",
      icons: ["https://nodejs.org/static/images/logo.svg"],
      name: "WalletConnect",
    },
  }
);

walletConnector.createSession().then(() => {
  const uri = walletConnector.uri;
  console.log(uri)
})

walletConnector.on("connect", (error, payload) => {
  if (error) {
    throw error;
  }

  // Get provided accounts and chainId
  const { accounts, chainId } = payload.params[0];
  console.log(accounts)
  console.log('chainId', chainId)
});
