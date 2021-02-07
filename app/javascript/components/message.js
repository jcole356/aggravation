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
  noSpan.innerHTML = "Steal";
  noSpan.addEventListener("click", stealApprovalHandler);
  return noSpan;
}

function yesButton() {
  const yesSpan = createElementWithClass("span", "confirm");
  yesSpan.innerHTML = "Pass";
  yesSpan.addEventListener("click", stealApprovalHandler);
  return yesSpan;
}

function render(message, prompt) {
  const messagesDiv = document.getElementsByClassName("messages")[0];
  messagesDiv.innerHTML = null;
  if (!message) {
    return;
  }
  let messageDiv = document.getElementsByClassName("message")[0];
  if (!messageDiv) {
    messageDiv = createElementWithClass("div", "message");
  } else {
    messageDiv.innerHTML = null;
  }
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
