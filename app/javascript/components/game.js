import {
  discardHandler,
  drawFromPileHandler,
  startHandler,
  state as appState,
} from "../app";
import Card from "../components/card";
import Player from "../components/player";

// Renders the top card of the discard pile
const renderDiscardPile = (pile) => {
  const pileDiv = document.getElementsByClassName("pile")[0];
  if (appState.turnState === "play") {
    pileDiv.removeEventListener("click", drawFromPileHandler);
    pileDiv.addEventListener("click", discardHandler);
  } else {
    pileDiv.removeEventListener("click", discardHandler);
    pileDiv.addEventListener("click", drawFromPileHandler);
  }

  if (!pile) {
    if (pileDiv.firstChild) {
      pileDiv.removeChild(pileDiv.firstChild);
    }
    return;
  }
  if (pileDiv.firstChild) {
    pileDiv.replaceChild(Card(pile), pileDiv.firstChild);
  } else {
    pileDiv.append(Card(pile));
  }
};

const render = ({ players, piles: { pile }, turn_state }) => {
  appState.turnState = turn_state;
  const header = document.getElementsByTagName("h1")[0];
  header.className = "hidden";
  const container = document.getElementsByClassName("players")[0];
  container.innerHTML = null;
  const current = document.getElementsByClassName("current-player")[0];
  current.innerHTML = null;
  renderDiscardPile(pile);
  players.forEach((player, idx) => {
    const isCurrentPlayer = appState.currentPlayer === idx;
    if (isCurrentPlayer) {
      current.append(Player(player, idx, isCurrentPlayer));
    } else {
      container.append(Player(player, idx, isCurrentPlayer));
    }
  });
  const button = document.getElementsByClassName("start-game")[0];
  if (!button) {
    return;
  }
  button.className = "reset hidden";
  button.innerHTML = "Reset";
  button.removeEventListener("click", startHandler);
};

export default render;
