import consumer from "./consumer";

// Find the players div, fill it with player divs
const showPlayers = (players) => {
  const container = document.getElementsByClassName("players")[0];
  container.innerHTML = null;
  players.forEach((player) => {
    const div = document.createElement("div");
    const span = document.createElement("span");
    span.append(player.label);
    div.append(span);
    div.append(player.hand);
    container.append(div);
  });
  const button = document.getElementsByClassName("start-game")[0];
  button.className = "draw-card"
  button.innerHTML = "Draw a Card"
};

export default consumer.subscriptions.create("GameNotificationsChannel", {
  // Called when the subscription is ready for use on the server
  connected() {
    console.log("Connected to the game", this);
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  // Called when there's incoming data on the websocket for this channel
  received(data) {
    const { state, type } = data;
    console.log("data", type);
    switch (type) {
      case "render": {
        showPlayers(state);
        break;
      }
      case "new":
      default: {
        break;
      }
    }
  },
});
