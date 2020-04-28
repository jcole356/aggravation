import Socket from './channels/game_notifications_channel.js';

document.addEventListener("turbolinks:load", () => {
  const button = document.getElementsByClassName('start-game')[0];
  button.addEventListener('click', () => {
    Socket.send({ action: 'play'});
  })
});



