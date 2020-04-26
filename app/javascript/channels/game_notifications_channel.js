import consumer from "./consumer"

consumer.subscriptions.create("GameNotificationsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('Connected to the game');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log('data', date.message);
    const div = document.getElementById('message-test');
    div.innerText = data.message;
  }
});
