
const point = () => {
  const applyPointBtn        = document.querySelector(".apply-point-btn");
  const pointInput           = document.getElementById("used-point-input");
  const hiddenUsedPointInput = document.getElementById("order_used_point");
  const hiddenCouponID = document.getElementById("order_coupon_id");
  const couponSelect         = document.getElementById("coupon-select");
  if (!applyPointBtn || !pointInput || !hiddenUsedPointInput || !couponSelect || !hiddenCouponID) return;// ボタンが存在しなければ終了

  const userPoint   = gon.user_point;
  const itemPrice   = gon.item_price;
  const userCoupons = gon.user_coupons;
  console.log(userCoupons)

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
    return itemPrice - itemPrice * discountRate / 100
  };

  const updateFinalPrice = () => {
    const selectedCouponAssignmentId = couponSelect.value;
    console.log(userCoupons)
    const discountRate               = userCoupons[selectedCouponAssignmentId] || 0;
    console.log("rate",selectedCouponAssignmentId , discountRate)
    const discountPrice              = calculateDiscountPrice(discountRate);

    const inputtedPoint = parseInt(pointInput.value, 10) || 0;
    const usedPoint     = validatesPoint(inputtedPoint, userPoint, discountPrice);

    const finalPrice = discountPrice - usedPoint;

    document.querySelector(".summary-row.total span:last-child").textContent = `¥${finalPrice}`;
    hiddenUsedPointInput.value     = usedPoint;
    hiddenCouponID.value = selectedCouponAssignmentId;
    pointInput.value               = usedPoint;
  };

  applyPointBtn.addEventListener("click", updateFinalPrice);
  couponSelect.addEventListener("change", updateFinalPrice);
};

window.addEventListener("turbo:load", point);
window.addEventListener("turbo:render", point);