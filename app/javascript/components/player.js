import Hand from './hand'
import Pile from './pile'

const renderPlayerInfo = ({ label, hand, score }) => {
  const div = document.createElement("div");
  div.className = "player-info";
  const nameSpan = document.createElement("span");
  nameSpan.append(label);
  const handSpan = document.createElement("span");
  handSpan.append(hand);
  const scoreSpan = document.createElement("span");
  scoreSpan.append(`${score} points`);
  div.append(nameSpan);
  div.append(handSpan);
  div.append(scoreSpan);

  return div;
};

const renderPlayerPiles = (piles, playerIdx) => {
  const div = document.createElement("div");
  div.className = "player-piles";
  piles.forEach((pile, idx) => {
    div.append(Pile(pile, idx, playerIdx));
  });

  return div;
};

// TODO: break up or annotate
const render = (player, idx, isCurrentPlayer) => {
  const div = document.createElement("div");
  div.className = "player-container";
  div.append(renderPlayerInfo(player, isCurrentPlayer));
  const cardsDiv = document.createElement("div");
  cardsDiv.className = 'cards-container';
  const handDiv = document.createElement("div");
  handDiv.className = "hand-container";
  handDiv.append(Hand(player.cards, isCurrentPlayer));
  cardsDiv.append(handDiv);
  cardsDiv.append(renderPlayerPiles(player.piles, idx, isCurrentPlayer));
  div.append(cardsDiv);

  return div;
};

export default render;
