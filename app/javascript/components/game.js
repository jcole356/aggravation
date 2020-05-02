import { drawHandler, playHandler, state as appState } from "../app";
import Card from "../components/card";
import Hand from "../components/hand";

const renderPiles = (piles) => {
  const pile = document.getElementsByClassName("pile")[0];
  if (pile.firstChild) {
    pile.replaceChild(Card(piles.pile), pile.firstChild);
  } else {
    pile.append(Card(piles.pile));
  }
};

const render = ({ players, piles }) => {
  const container = document.getElementsByClassName("players")[0];
  container.innerHTML = null;
  renderPiles(piles);
  players.forEach((player, idx) => {
    const div = document.createElement("div");
    div.className = "player-container";
    const span = document.createElement("span");
    span.append(player.label);
    span.className = "player-label";
    div.append(span);
    // div.append(player.hand);
    div.append(Hand(player.cards, appState.currentPlayer === idx));
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

export default render;
