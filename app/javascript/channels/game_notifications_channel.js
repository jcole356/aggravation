import consumer from "./consumer";
import { drawHandler, playHandler } from "../app";

const socket = consumer.subscriptions.create("GameNotificationsChannel", {
  // Called when the subscription is ready for use on the server
  connected() {
    console.log("Connected to the game", this);
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  // Called when there's incoming data on the websocket for this channel
  received(data) {
    const { state, type } = data;
    console.log("data", type);
    switch (type) {
      case "render": {
        console.log("state", state);
        showPlayers(state);
        break;
      }
      case "new":
      default: {
        console.log("default");
        break;
      }
    }
  },
});

const renderCard = ({ suit, value }) => {
  const suitDiv = document.createElement("div");
  suitDiv.className = `suit-${suit.toLowerCase()}`;
  suitDiv.append(suit);
  const valueDiv = document.createElement("div");
  valueDiv.className = "value";
  valueDiv.append(value);
  const div = document.createElement("div");
  div.className = `card ${suit.toLowerCase()}`;
  div.append(valueDiv);
  div.append(suitDiv);
  return div;
};

const renderHand = (cards) => {
  const hand = document.createElement("div");
  hand.className = "hand";
  cards.forEach((card) => {
    const div = renderCard(card);
    hand.append(div);
  });
  return hand;
};

// Find the players div, fill it with player divs
const showPlayers = (players) => {
  const container = document.getElementsByClassName("players")[0];
  container.innerHTML = null;
  players.forEach((player) => {
    const div = document.createElement("div");
    div.className = "player-container";
    const span = document.createElement("span");
    span.append(player.label);
    span.className = "player-label";
    div.append(span);
    // div.append(player.hand);
    div.append(renderHand(player.cards));
    container.append(div);
  });
  const button = document.getElementsByClassName("start-game")[0];
  button.className = "draw-card";
  button.innerHTML = "Draw a Card";
  button.removeEventListener("click", playHandler);
  button.addEventListener("click", drawHandler);
};

export default socket;
