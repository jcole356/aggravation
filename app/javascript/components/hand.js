import Card from "../components/card";

const render = (cards, isCurrentPlayer) => {
  const hand = document.createElement("div");
  hand.className = "hand";
  cards.forEach((card, idx) => {
    const div = Card(card, isCurrentPlayer ? idx : null);
    hand.append(div);
  });
  return hand;
};

export default render;
