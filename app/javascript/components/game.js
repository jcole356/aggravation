import {
  discardHandler,
  drawFromPileHandler,
  startHandler,
  state as appState,
} from "../app";
import Card from "../components/card";
import Hand from "../components/hand";
import Pile from "../components/pile";

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

const renderPlayerName = (label, isCurrentPlayer) => {
  const nameDiv = document.createElement("div");
  nameDiv.className = "player-label";
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

const renderPlayerPiles = (piles, playerIdx) => {
  const div = document.createElement("div");
  div.className = "player-piles";
  piles.forEach((pile, idx) => {
    div.append(Pile(pile, idx, playerIdx));
  });

  return div;
};

const renderPlayer = (player, idx, isCurrentPlayer) => {
  const div = document.createElement("div");
  div.className = "player-container";
  const handDiv = document.createElement("div");
  handDiv.className = "hand-container";
  handDiv.append(renderPlayerInfo(player, isCurrentPlayer));
  handDiv.append(Hand(player.cards, isCurrentPlayer));
  div.append(handDiv);
  div.append(renderPlayerPiles(player.piles, idx, isCurrentPlayer));

  return div;
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
      current.append(renderPlayer(player, idx, isCurrentPlayer));
    } else {
      container.append(renderPlayer(player, idx, isCurrentPlayer));
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
