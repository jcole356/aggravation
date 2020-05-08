import Socket from "./channels/game_notifications_channel.js";

export const state = {};

export function discardHandler(e) {
  const idx = e.currentTarget.getAttribute("data-idx");
  Socket.send({ action: "discard", choice: idx, player: state.currentPlayer });
}

export function drawFromDeckHandler() {
  Socket.send({ action: "draw", choice: "deck", player: state.currentPlayer });
}

export function drawFromPileHandler() {
  Socket.send({ action: "draw", choice: "pile", player: state.currentPlayer });
}

export function playHandler(e) {
  const idx = e.currentTarget.getAttribute("data-idx");
  Socket.send({
    action: "play",
    pile_idx: idx,
    card_idx: state.selectedCard,
    player: state.currentPlayer,
  });
}

export function startHandler() {
  Socket.send({ action: "start" });
}

document.addEventListener("turbolinks:load", () => {
  const button = document.getElementsByClassName("start-game")[0];
  button.addEventListener("click", startHandler);
  const deck = document.getElementsByClassName("deck")[0];
  deck.addEventListener("click", drawFromDeckHandler);
  const pile = document.getElementsByClassName("pile")[0];
  pile.addEventListener("click", drawFromPileHandler);
});
