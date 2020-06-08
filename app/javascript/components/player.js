import Hand from "./hand";
import Pile from "./pile";
import { createElementWithClass } from "../utils";

const renderPlayerInfo = ({ label, hand, score }) => {
  const playerDiv = createElementWithClass("div", "player-info");
  const nameSpan = document.createElement("span");
  nameSpan.append(label);
  const handSpan = document.createElement("span");
  handSpan.append(hand);
  const scoreSpan = document.createElement("span");
  scoreSpan.append(`${score} points`);
  playerDiv.append(nameSpan);
  playerDiv.append(handSpan);
  playerDiv.append(scoreSpan);

  return playerDiv;
};

const renderPlayerPiles = (piles, playerIdx) => {
  const div = createElementWithClass("div", "player-piles");
  piles.forEach((pile, idx) => {
    div.append(Pile(pile, idx, playerIdx));
  });

  return div;
};

const render = (player, idx, isCurrentPlayer) => {
  const div = createElementWithClass("div", "player-container");
  if (isCurrentPlayer) {
    div.classList.add("current");
  }
  div.append(renderPlayerInfo(player, isCurrentPlayer));
  const cardsDiv = createElementWithClass("div", "cards-container");
  const handDiv = createElementWithClass("div", "hand-container");
  handDiv.append(Hand(player.cards, isCurrentPlayer));
  cardsDiv.append(handDiv);
  cardsDiv.append(renderPlayerPiles(player.piles, idx, isCurrentPlayer));
  div.append(cardsDiv);

  return div;
};

export default render;
