import consumer from "./consumer";
import { state as appState } from "../app";
import Game from "../components/game";

const socket = consumer.subscriptions.create("GameNotificationsChannel", {
  // Called when the subscription is ready for use on the server
  connected() {
    console.log("Connected to the game", this);
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  // Called when there's incoming data on the websocket for this channel
  received({ state, type }) {
    console.log("data", type);
    switch (type) {
      case "join": {
        console.log("SOMEONE JOINED THE GAME");
        break;
      }
      default: {
        console.log("default");
        break;
      }
    }
  },
});

export default socket;
