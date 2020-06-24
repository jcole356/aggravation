import consumer from "./consumer";
import { createElementWithClass } from "../utils";

const socket = consumer.subscriptions.create("GameNotificationsChannel", {
  // Called when the subscription is ready for use on the server
  connected() {
    console.log("Connected to the game", this);
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  // Called when there's incoming data on the websocket for this channel
  received({ message, state, type }) {
    console.log("data", type);
    switch (type) {
      case "join": {
        console.log("SOMEONE JOINED THE GAME");
        const playersDiv = document.getElementsByClassName("players")[0];
        playersDiv.innerHTML = `Number of players: ${state.playerCount}`;
        break;
      }
      case "steal": {
        // TODO: messages should render somewhere (HUD?)
        console.log("message", message);
        const messagesDiv = document.getElementsByClassName("messages")[0];
        const messageDiv = createElementWithClass("div", "message");
        messageDiv.innerHTML = message;
        messagesDiv.append(messageDiv);
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
