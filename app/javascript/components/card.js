const symbols = {
  c: "\u2663",
  d: "\u2666",
  h: "\u2665",
  s: "\u2660",
};

const renderCard = ({ suit, value }) => {
  const parsedSuit = (suit && suit.toLowerCase()) || value.toLowerCase();
  const suitDiv = document.createElement("div");
  suitDiv.className = `suit-${parsedSuit}`;
  suitDiv.append(symbols[parsedSuit]);
  const valueDiv = document.createElement("div");
  valueDiv.className = "value";
  valueDiv.append(value);
  const div = document.createElement("div");
  div.className = `card ${parsedSuit}`;
  div.append(valueDiv);
  div.append(suitDiv);
  return div;
};

export default renderCard;
