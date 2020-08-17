import PlayerSocket from "../channels/player_notifications_channel";
import { createElementWithClass } from "../utils";

function stealApprovalHandler(e) {
  const value = e.currentTarget.classList[0]
  PlayerSocket.send({
    action: `steal_${value}`,
  })
}

// TODO: combine these buttons
// TODO: not sure the classes are required
function noButton() {
  const noSpan = createElementWithClass("span", "deny");
  noSpan.innerHTML = "No";
  noSpan.addEventListener("click", stealApprovalHandler);
  return noSpan;
}

function yesButton() {
  const yesSpan = createElementWithClass("span", "confirm");
  yesSpan.innerHTML = "Yes";
  yesSpan.addEventListener("click", stealApprovalHandler);
  return yesSpan;
}

// TODO: send a message per user
function render(message, prompt) {
  const messagesDiv = document.getElementsByClassName("messages")[0];
  const messageDiv = createElementWithClass("div", "message");
  const messageSpan = createElementWithClass("span");
  messageSpan.innerHTML = message;
  messageDiv.append(messageSpan);
  messagesDiv.append(messageDiv);
  if (prompt) {
    const dividerSpan = createElementWithClass("span");
    dividerSpan.innerHTML = "/"
    messageDiv.append(yesButton())
    messageDiv.append(dividerSpan)
    messageDiv.append(noButton())
  }
  return messagesDiv;
}

export default render;
