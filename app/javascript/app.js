import Socket from "./channels/game_notifications_channel.js";

export const state = {};

export function discardHandler(e) {
  const idx = e.currentTarget.getAttribute('data-idx');
  Socket.send({ action: "discard", choice: idx, player: state.currentPlayer });
}

export function drawFromDeckHandler() {
  Socket.send({ action: "draw", choice: "deck", player: state.currentPlayer });
}

export function drawFromPileHandler() {
  Socket.send({ action: "draw", choice: "pile", player: state.currentPlayer });
}

export function playHandler() {
  Socket.send({ action: "play" });
}

document.addEventListener("turbolinks:load", () => {
  const button = document.getElementsByClassName("start-game")[0];
  button.addEventListener("click", playHandler);
  const deck = document.getElementsByClassName("deck")[0];
  deck.addEventListener("click", drawFromDeckHandler);
  const pile = document.getElementsByClassName("pile")[0];
  pile.addEventListener("click", drawFromPileHandler);
});
