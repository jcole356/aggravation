import { play, playHandler, state } from "../app";
import Card from "./card";
import { createElementWithClass } from "../utils";

function cardTargetSelectHandler(e) {
  e.stopPropagation();
  const currentTarget = e.currentTarget;
  const idx = currentTarget.getAttribute("data-idx");
  if (state.targetCard === idx) {
    state.targetCard = undefined;
    return;
  }
  state.targetCard = idx;
  const pileNode = currentTarget.parentNode.parentNode;
  const pileIdx = pileNode.getAttribute("data-idx");
  const playerIdx = pileNode.getAttribute("data-player-idx");
  play(playerIdx, pileIdx, idx);
}

const render = ({ cards, label }, idx, playerIdx) => {
  const pileDiv = createElementWithClass("div", "hand-pile");
  pileDiv.setAttribute("data-idx", idx);
  pileDiv.setAttribute("data-player-idx", playerIdx);
  pileDiv.addEventListener("click", playHandler);
  const pileLabel = createElementWithClass("div", "hand-pile-label");
  pileLabel.append(label);
  const pileCards = createElementWithClass("div", "hand-pile-cards");
  const handler = cardTargetSelectHandler;
  cards.forEach((card, idx) => {
    pileCards.append(Card(card, idx, handler));
  });
  pileDiv.append(pileLabel);
  pileDiv.append(pileCards);

  return pileDiv;
};

export default render;
