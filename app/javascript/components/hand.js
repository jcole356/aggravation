import Card from "../components/card";
import { createElementWithClass } from "../utils"

const render = (cards, isCurrentPlayer) => {
  const hand = createElementWithClass("div", "hand");
  cards.forEach((card, idx) => {
    const div = Card(card, isCurrentPlayer ? idx : null);
    hand.append(div);
  });
  return hand;
};

export default render;
