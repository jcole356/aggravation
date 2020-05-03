import { drawFromDeckHandler, playHandler, state as appState } from "../app";
import Card from "../components/card";
import Hand from "../components/hand";

// Renders the top card of the discard pile
const renderPiles = (pile) => {
  const pileDiv = document.getElementsByClassName("pile")[0];

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

const render = ({ players, piles: { pile } }) => {
  const container = document.getElementsByClassName("players")[0];
  container.innerHTML = null;
  renderPiles(pile);
  players.forEach((player, idx) => {
    const isCurrentPlayer = appState.currentPlayer === idx;
    const div = document.createElement("div");
    div.className = "player-container";
    const nameDiv = document.createElement("div");
    nameDiv.className = `player-label${isCurrentPlayer ? " current" : ""}`;
    const span = document.createElement("span");
    span.append(player.label);
    nameDiv.append(span);
    div.append(nameDiv);
    // div.append(player.hand);
    div.append(Hand(player.cards, isCurrentPlayer));
    container.append(div);
  });
  const button = document.getElementsByClassName("start-game")[0];
  if (!button) {
    return;
  }
  button.className = "draw-card";
  button.innerHTML = "Draw a Card";
  button.removeEventListener("click", playHandler);
  button.addEventListener("click", drawFromDeckHandler);
};

export default render;
