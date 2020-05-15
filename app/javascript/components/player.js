import Hand from './hand'
import Pile from './pile'

const renderPlayerName = (label, isCurrentPlayer) => {
  const nameDiv = document.createElement("div");
  nameDiv.className = "player-label";
  const span = document.createElement("span");
  span.append(label);
  nameDiv.append(span);

  return nameDiv;
};

const renderPlayerInfo = ({ label, hand }, isCurrentPlayer) => {
  const div = document.createElement("div");
  div.className = "player-info";
  const handSpan = document.createElement("span");
  handSpan.append(hand);
  div.append(renderPlayerName(label, isCurrentPlayer));
  div.append(handSpan);

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

const render = (player, idx, isCurrentPlayer) => {
  const div = document.createElement("div");
  div.className = "player-container";
  const handDiv = document.createElement("div");
  handDiv.className = "hand-container";
  handDiv.append(renderPlayerInfo(player, isCurrentPlayer));
  handDiv.append(Hand(player.cards, isCurrentPlayer));
  div.append(handDiv);
  div.append(renderPlayerPiles(player.piles, idx, isCurrentPlayer));

  return div;
};

export default render;
