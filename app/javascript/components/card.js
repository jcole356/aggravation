import { state } from "../app";
import { createElementWithClass } from "../utils";

// TODO: move to constants
const symbols = {
  c: "\u2663",
  d: "\u2666",
  h: "\u2665",
  s: "\u2660",
};

function cardSelectHandler(e) {
  unselectCards();
  const currentTarget = e.currentTarget;
  const idx = currentTarget.getAttribute("data-idx");
  if (state.selectedCard === idx) {
    state.selectedCard = undefined;
    return;
  }
  state.selectedCard = idx;
  currentTarget.classList.add("selected");
}

function unselectCards() {
  const cards = document.getElementsByClassName("card");
  Array.prototype.forEach.call(cards, (card) => {
    if (card.classList.contains("selected")) {
      card.classList.remove("selected");
    }
  });
}

const render = ({ suit, value }, idx = null, handler = cardSelectHandler) => {
  const parsedSuit = (suit && suit.toLowerCase()) || value.toLowerCase();
  const suitDiv = createElementWithClass("div", `suit-${parsedSuit}`);
  suitDiv.append(symbols[parsedSuit]);
  const valueDiv = createElementWithClass("div", "value");
  valueDiv.append(value);
  const div = createElementWithClass("div", `card ${parsedSuit}`);
  // Only set the handler for current player
  if (idx !== null) {
    div.setAttribute("data-idx", `${idx}`);
    div.addEventListener("click", handler);
  }
  div.append(valueDiv);
  div.append(suitDiv);

  return div;
};

export default render;
