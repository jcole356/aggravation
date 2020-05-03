import { playHandler, state as appState } from "../app";
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

const renderPlayerName = (label, isCurrentPlayer) => {
  const nameDiv = document.createElement("div");
  nameDiv.className = `player-label${isCurrentPlayer ? " current" : ""}`;
  const span = document.createElement("span");
  span.append(label);
  nameDiv.append(span);

  return nameDiv;
};

const renderPlayerInfo = ({ label, hand }, isCurrentPlayer) => {
  const div = document.createElement("div");
  div.className = "player-info";
  const handSpan = document.createElement("span");
  handSpan.append(hand);
  div.append(renderPlayerName(label, isCurrentPlayer));
  div.append(handSpan);

  return div;
};

const renderPlayer = (player, isCurrentPlayer) => {
  const div = document.createElement("div");
  div.className = "player-container";
  div.append(renderPlayerInfo(player, isCurrentPlayer));
  div.append(Hand(player.cards, isCurrentPlayer));

  return div;
};

const render = ({ players, piles: { pile } }) => {
  const container = document.getElementsByClassName("players")[0];
  container.innerHTML = null;
  renderPiles(pile);
  players.forEach((player, idx) => {
    const isCurrentPlayer = appState.currentPlayer === idx;
    container.append(renderPlayer(player, isCurrentPlayer));
  });
  const button = document.getElementsByClassName("start-game")[0];
  if (!button) {
    return;
  }
  button.className = "reset";
  button.innerHTML = "Reset";
  button.removeEventListener("click", playHandler);
  // button.addEventListener("click", drawFromDeckHandler);
};

export default render;
