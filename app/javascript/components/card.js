import { state } from "../app";

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
  if (state.selectedCard === idx){
    state.selectedCard = undefined;
    return;
  }
  state.selectedCard = idx;
  currentTarget.classList.add('selected');
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
  const suitDiv = document.createElement("div");
  suitDiv.className = `suit-${parsedSuit}`;
  suitDiv.append(symbols[parsedSuit]);
  const valueDiv = document.createElement("div");
  valueDiv.className = "value";
  valueDiv.append(value);
  const div = document.createElement("div");
  // Only set the handler for current player
  if (idx !== null) {
    div.setAttribute("data-idx", `${idx}`);
    div.addEventListener("click", handler);
  }
  div.className = `card ${parsedSuit}`;
  div.append(valueDiv);
  div.append(suitDiv);
  return div;
};

export default render;
