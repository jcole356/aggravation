import Socket from "./channels/game_notifications_channel.js";

export function playHandler() {
  Socket.send({ action: "play" });
}

export function drawHandler() {
  Socket.send({ action: "draw" });
}

document.addEventListener("turbolinks:load", () => {
  const button = document.getElementsByClassName("start-game")[0];
  button.addEventListener("click", playHandler);
});
