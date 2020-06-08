import GameSocket from "./channels/game_notifications_channel.js";
import PlayerSocket from "./channels/player_notifications_channel.js";

/**
 * currentPlayer - player whose turn it is
 * selectedCard - currently selected card
 * turnState - state of the current players turn
 */
export const state = {};

export function discardHandler() {
  PlayerSocket.send({
    action: "discard",
    choice: state.selectedCard,
    player: state.currentPlayer,
  });
  state.selectedCard = undefined;
}

export function drawFromDeckHandler() {
  PlayerSocket.send({ action: "draw", choice: "deck", player: state.currentPlayer });
}

// Assumes a player doesn't want to draw if they've selected a card
export function drawFromPileHandler() {
  if (state.selectedCard !== undefined) {
    return;
  }

  PlayerSocket.send({ action: "draw", choice: "pile", player: state.currentPlayer });
}

export function joinHandler() {
  const input = document.getElementsByName("name")[0];
  PlayerSocket.send({ action: "join", name: input.value });
}

export function playHandler(e) {
  const idx = e.currentTarget.getAttribute("data-idx");
  const playerIdx = e.currentTarget.getAttribute("data-player-idx");
  const otherCardIdx = e.target.getAttribute("data-idx");
  state.targetCard = otherCardIdx;
  PlayerSocket.send({
    action: "play",
    card_idx: parseInt(state.selectedCard, 10),
    pile_idx: parseInt(idx, 10),
    pile_player_idx: parseInt(playerIdx, 10),
    player: state.currentPlayer,
    target_card_idx: parseInt(state.targetCard, 10),
  });
  state.targetCard = undefined;
}

export function play(playerIdx, pileIdx, cardIdx) {
  PlayerSocket.send({
    action: "play",
    card_idx: parseInt(state.selectedCard, 10),
    pile_idx: parseInt(pileIdx, 10),
    pile_player_idx: parseInt(playerIdx, 10),
    player: state.currentPlayer, // Should this really live here?
    target_card_idx: parseInt(cardIdx, 10),
  });
}

export function startHandler() {
  GameSocket.send({ action: "start" });
}

document.addEventListener("turbolinks:load", () => {
  const joinButton = document.getElementsByClassName("join-game")[0];
  joinButton.addEventListener("click", joinHandler);
  const startButton = document.getElementsByClassName("start-game")[0];
  startButton.addEventListener("click", startHandler);
  const deck = document.getElementsByClassName("deck")[0];
  deck.addEventListener("click", drawFromDeckHandler);
});
