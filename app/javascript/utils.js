export const createElementWithClass = (type, classname) => {
  const el = document.createElement(type);
  el.className = classname;

  return el;
};
