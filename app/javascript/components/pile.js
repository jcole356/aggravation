import { playHandler } from "../app";
import Card from "./card";

const render = ({ cards, label }, idx) => {
  const pileDiv = document.createElement("div");
  pileDiv.className = "hand-pile";
  pileDiv.setAttribute("data-idx", idx);
  pileDiv.addEventListener("click", playHandler);
  const pileLabel = document.createElement("div");
  pileLabel.append(label);
  pileLabel.className = "hand-pile-label";
  const pileCards = document.createElement("div");
  pileCards.className = "hand-pile-cards";
  cards.forEach((card) => {
    pileCards.append(Card(card));
  });
  pileDiv.append(pileLabel);
  pileDiv.append(pileCards);

  return pileDiv;
};

export default render;
