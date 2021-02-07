import consumer from "./consumer"
import { state as appState } from "../app";
import Game from "../components/game";
import Message from "../components/message";

const socket = consumer.subscriptions.create("PlayerNotificationsChannel", {
  // Called when the subscription is ready for use on the server
  connected() {
    console.log("Connected to player notifications", this);
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  // Called when there's incoming data on the websocket for this channel
  received({ message, prompt, state, type }) {
    console.log("data", type);
    switch (type) {
      case "render": {
        console.log("state", state);
        appState.currentPlayer = state.current_player_idx;
        Game(state);
        break;
      }
      case "steal": {
        console.log("message", message, prompt);
        Message(message, prompt);
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
