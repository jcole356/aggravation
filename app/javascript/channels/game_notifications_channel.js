import consumer from "./consumer"

export default consumer.subscriptions.create("GameNotificationsChannel", {
  // Called when the subscription is ready for use on the server
  connected() {
    console.log('Connected to the game', this);
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  // Called when there's incoming data on the websocket for this channel
  received(data) {
    console.log('data', data.type);
    switch(data.type) {
      case 'new': {
        const div = document.getElementById('message-test');
        div.innerText = 'Game started';
        break;
      }
      default:{
        console.log('default behavior here');
        break;
      }
    }
  }
});
