
const point = () => {
  const applyPointBtn = document.querySelector(".apply-point-btn");
  const pointInput = document.getElementById("used-point-input");
  const hiddenUsedPointInput = document.getElementById("order_used_point");
  if (!applyPointBtn || !pointInput || !hiddenUsedPointInput) return;// ボタンが存在しなければ終了

  const userPoint = gon.user_point;
  const itemPrice = gon.item_price;

  applyPointBtn.addEventListener("click", () => {
    console.log("click")
    let usedPoint = parseInt(pointInput.value, 10) || 0;

     // バリデーション
    if (
      usedPoint < 0 ||
      usedPoint > userPoint ||
      usedPoint > itemPrice
    ) {
      usedPoint = 0;
    }

    // ここで支払金額の再計算や表示の更新を行うことも可能
    const finalPrice = Math.max(itemPrice - usedPoint, 0);
    document.querySelector(".summary-row.total span:last-child").textContent = `¥${finalPrice}`;

    hiddenUsedPointInput.value = usedPoint; // railsに渡す使用ポイント数を設定
    pointInput.value = usedPoint; // 表示するポイントを再設定
  });
};

window.addEventListener("turbo:load", point);
window.addEventListener("turbo:render", point);