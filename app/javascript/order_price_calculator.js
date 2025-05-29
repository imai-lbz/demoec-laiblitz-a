
const point = () => {
  const applyPointBtn        = document.querySelector(".apply-point-btn");
  const pointInput           = document.getElementById("used-point-input");
  const hiddenUsedPointInput = document.getElementById("order_used_point");
  const hiddenCouponID = document.getElementById("order_coupon_id");
  const couponSelect         = document.getElementById("coupon-select");
  if (!applyPointBtn || !pointInput || !hiddenUsedPointInput || !couponSelect || !hiddenCouponID) return;// ボタンが存在しなければ終了
  const couponRow = document.getElementById("applied-coupon-price");
  const couponAmountSpan = document.getElementById("coupon-discount-amount");
  if (!couponRow || !couponAmountSpan) return;
  const pointRow = document.getElementById("applied-point-price");
  const pointAmountSpan = document.getElementById("point-discount-amount");
  if (!pointRow || !pointAmountSpan) return;

  const userPoint   = gon.user_point;
  const itemPrice   = gon.item_price;
  const userCoupons = gon.user_coupons;

  const updateCouponRow = (discountAmount) => {
    if (discountAmount > 0) {
      couponAmountSpan.textContent = `- ¥${discountAmount.toLocaleString()}`;
      couponRow.style.display = ""; // 表示（block または初期値）
    } else {
      couponRow.style.display = "none"; // 非表示
    }
  };
    const updatePointRow = (discountAmount) => {
    if (discountAmount > 0) {
      pointAmountSpan.textContent = `- ¥${discountAmount.toLocaleString()}`;
      pointRow.style.display = ""; // 表示（block または初期値）
    } else {
      pointRow.style.display = "none"; // 非表示
    }
  };


  const validatesPoint = (point, userPoint, price) =>{
    if (
      point < 0 ||
      point > userPoint ||
      point > price
    ) {
      return 0
    }
    return point
  };

  const calculateDiscountPrice = (discountRate) =>{
    // return itemPrice - itemPrice * discountRate / 100
    const discount = Math.floor(itemPrice * discountRate / 100);
    return itemPrice - discount;
  };

  const updateFinalPrice = () => {
    const selectedCouponAssignmentId = couponSelect.value;
    console.log(userCoupons)
    const discountRate               = userCoupons[selectedCouponAssignmentId] || 0;
    console.log("rate",selectedCouponAssignmentId , discountRate)
    const discountPrice              = calculateDiscountPrice(discountRate);

    updateCouponRow(itemPrice - discountPrice);

    const inputtedPoint = parseInt(pointInput.value, 10) || 0;
    const usedPoint     = validatesPoint(inputtedPoint, userPoint, discountPrice);

    updatePointRow(usedPoint)

    const finalPrice = discountPrice - usedPoint;

    document.querySelector(".summary-row.total span:last-child").textContent = `¥${finalPrice}`;
    hiddenUsedPointInput.value     = usedPoint;
    hiddenCouponID.value = selectedCouponAssignmentId;
    pointInput.value               = usedPoint;
  };

  applyPointBtn.addEventListener("click", updateFinalPrice);
  couponSelect.addEventListener("change", updateFinalPrice);
  updateFinalPrice()
};

window.addEventListener("turbo:load", point);
window.addEventListener("turbo:render", point);
