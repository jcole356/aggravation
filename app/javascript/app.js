import Socket from "./channels/game_notifications_channel.js";

export const state = {};

export function discardHandler(e) {
  const idx = e.currentTarget.getAttribute('data-idx');
  Socket.send({ action: "discard", choice: idx, player: state.currentPlayer });
}

export function drawHandler() {
  Socket.send({ action: "draw", choice: "deck", player: state.currentPlayer });
}

export function playHandler() {
  Socket.send({ action: "play" });
}

document.addEventListener("turbolinks:load", () => {
  const button = document.getElementsByClassName("start-game")[0];
  button.addEventListener("click", playHandler);
});
