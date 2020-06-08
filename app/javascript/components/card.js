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

function renderObfuscatedCard() {
  return createElementWithClass("div", "obfuscated-card");
}

function unselectCards() {
  const cards = document.getElementsByClassName("card");
  Array.prototype.forEach.call(cards, (card) => {
    if (card.classList.contains("selected")) {
      card.classList.remove("selected");
    }
  });
}

const render = ({ obfuscate, suit, value }, idx = null, handler = cardSelectHandler, numCards) => {
  if (obfuscate) {
    return renderObfuscatedCard();
  }
  const leftHalf = createElementWithClass("div", 'card-left');
  const rightHalf = createElementWithClass("div", 'card-right');
  const parsedSuit = (suit && suit.toLowerCase()) || value.toLowerCase();
  const suitDiv = createElementWithClass("div", `suit-${parsedSuit}`);
  suitDiv.append(symbols[parsedSuit]);
  const valueDiv = createElementWithClass("div", "value");
  valueDiv.append(value);
  const div = createElementWithClass("div", `card ${parsedSuit}`);
  div.append(valueDiv);
  div.append(suitDiv);
  if (idx !== null) {
    if (numCards == 1) {
      leftHalf.setAttribute("data-idx", '0');
      leftHalf.addEventListener("click", handler);
      rightHalf.setAttribute("data-idx", '1');
      rightHalf.addEventListener("click", handler);
      div.append(leftHalf);
      div.append(rightHalf);
    } else {
      div.setAttribute("data-idx", `${idx}`);
      div.addEventListener("click", handler);
    }
  }

  return div;
};

export default render;
