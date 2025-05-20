
const point = () => {
  
  console.log("pointが呼ばれたよ")
};

window.addEventListener("turbo:load", point);
window.addEventListener("turbo:render", point);