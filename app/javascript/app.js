import Socket from "./channels/game_notifications_channel.js";

/**
 * currentPlayer - player whose turn it is
 * selectedCard - currently selected card
 * turnState - state of the current players turn
 */
export const state = {};

export function discardHandler() {
  Socket.send({
    action: "discard",
    choice: state.selectedCard,
    player: state.currentPlayer,
  });
}

export function drawFromDeckHandler() {
  Socket.send({ action: "draw", choice: "deck", player: state.currentPlayer });
}

// Assumes a player doesn't want to discard if they've selected a card
export function drawFromPileHandler() {
  if (state.selectedCard !== undefined) {
    return;
  }

  Socket.send({ action: "draw", choice: "pile", player: state.currentPlayer });
}

export function playHandler(e) {
  const idx = e.currentTarget.getAttribute("data-idx");
  Socket.send({
    action: "play",
    pile_idx: parseInt(idx, 10),
    card_idx: parseInt(state.selectedCard, 10),
    player: state.currentPlayer, // Should this really live here?
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
});
