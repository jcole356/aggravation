import Socket from "./channels/game_notifications_channel.js";

// TODO: players need to be dynamically set
export function discardHandler(e) {
  const idx = e.target.getAttribute('data-idx');
  Socket.send({ action: "discard", choice: idx, player: 0 });
}

export function drawHandler() {
  Socket.send({ action: "draw", choice: "deck", player: 0 });
}

export function playHandler() {
  Socket.send({ action: "play" });
}

document.addEventListener("turbolinks:load", () => {
  const button = document.getElementsByClassName("start-game")[0];
  button.addEventListener("click", playHandler);
});
