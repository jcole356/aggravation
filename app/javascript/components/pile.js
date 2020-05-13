import { play, playHandler, state } from "../app";
import Card from "./card";

// Set this on all piles except your own
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
  const pileDiv = document.createElement("div");
  pileDiv.className = "hand-pile";
  pileDiv.setAttribute("data-idx", idx);
  pileDiv.setAttribute("data-player-idx", playerIdx);
  pileDiv.addEventListener("click", playHandler);
  const pileLabel = document.createElement("div");
  pileLabel.append(label);
  pileLabel.className = "hand-pile-label";
  const pileCards = document.createElement("div");
  pileCards.className = "hand-pile-cards";
  const handler =
    playerIdx === state.currentPlayer ? null : cardTargetSelectHandler;
  cards.forEach((card, idx) => {
    pileCards.append(Card(card, idx, handler));
  });
  pileDiv.append(pileLabel);
  pileDiv.append(pileCards);

  return pileDiv;
};

export default render;
