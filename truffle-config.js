require('babel-register');
require('babel-polyfill');
require('dotenv').config();

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
  },
  contracts_directory: './contracts',
  contracts_build_directory: './build/contracts',
  compilers: {
    solc: {
      version: "0.8.0",   // fetch exact
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
}