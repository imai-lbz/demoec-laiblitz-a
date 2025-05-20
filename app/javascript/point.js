
const point = () => {
  const applyPointBtn = document.querySelector(".apply-point-btn");
  const pointInput = document.getElementById("used-point-input");

  if (!applyPointBtn || !pointInput) return;// ボタンが存在しなければ終了


  const userPoint = gon.user_point;  // ← 所持ポイントを取得
  console.log("所持ポイント:", userPoint);

  console.log("pointが呼ばれたよ")

  applyPointBtn.addEventListener("click", () => {
    console.log("click")
    let usedPoint = parseInt(pointInput.value, 10) || 0;

     // バリデーション: マイナスまたは所持ポイント以上なら 0 にする
    if (usedPoint < 0 || usedPoint > userPoint) {
      usedPoint = 0;
      pointInput.value = 0; // フォーム上の値もリセット
    }

    // ここで支払金額の再計算や表示の更新を行うことも可能
    const itemPrice = gon.item_price; // 例：gonで渡していれば
    const finalPrice = Math.max(itemPrice - usedPoint, 0);
    document.querySelector(".summary-row.total span:last-child").textContent = `¥${finalPrice}`;
  });
};

window.addEventListener("turbo:load", point);
window.addEventListener("turbo:render", point);