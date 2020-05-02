import consumer from "./consumer";
import { drawHandler, playHandler } from "../app";
import Card from "../components/card";

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
        showPiles(state.piles);
        showPlayers(state.players);
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

const renderHand = (cards) => {
  const hand = document.createElement("div");
  hand.className = "hand";
  cards.forEach((card, idx) => {
    const div = Card(card, idx);
    hand.append(div);
  });
  return hand;
};

const showPiles = (piles) => {
  console.log("pile", piles.pile);
  const pile = document.getElementsByClassName('pile')[0];
  if (pile.firstChild) {
    pile.replaceChild(Card(piles.pile), pile.firstChild);
  } else {
    pile.append(Card(piles.pile));
  }
};

// TODO: render the piles as well
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
  if (!button) {
    return;
  }
  button.className = "draw-card";
  button.innerHTML = "Draw a Card";
  button.removeEventListener("click", playHandler);
  button.addEventListener("click", drawHandler);
};

export default socket;
