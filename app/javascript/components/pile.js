import Card from "./card"

// TODO: add listeners to play selected card
const render = ({ cards, label }) => {
  const pileDiv = document.createElement("div");
  pileDiv.className = "hand-pile";
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
