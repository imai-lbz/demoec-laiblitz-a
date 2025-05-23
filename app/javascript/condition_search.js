const search = () => {
  const items = gon.items;
  console.log("全商品データ (gon.items):", items);

  const conditionSelect = document.getElementById("item-condition-select");
  const productsGrid = document.getElementById("products-grid");

  if (conditionSelect && productsGrid) {
    const filterAndDisplayItems = () => {
      const selectedConditionId = conditionSelect.value;

      let filteredItems = [];
      if (selectedConditionId === "") {
        filteredItems = items;
      } else {
        filteredItems = items.filter(item => {
          return item.condition_id.toString() === selectedConditionId;
        });
      }

      console.log("絞り込み後の商品データ:", filteredItems);
      productsGrid.innerHTML = '';

      if (filteredItems.length > 0) {
        filteredItems.forEach(item => {
          const itemElement = document.createElement('div');
          itemElement.classList.add('product-item');
          const linkElement = document.createElement('a');
          linkElement.href = `/items/${item.id}`; 
          linkElement.classList.add('product-item-link');
          let soldOutBadgeHtml = '';
          if (item.is_sold_out) {
            soldOutBadgeHtml = '<div class="sold-out-badge">在庫なし</div>';
          }
          linkElement.innerHTML = `
            <div class="product-image-container">
              <img class="product-image" src="${item.image_url}" alt="${item.name}">
              ${soldOutBadgeHtml}
            </div>
            <div class="product-content">
              <div class="product-category">${item.category_name || 'その他'}</div>
              <h3 class="product-name">${item.name}</h3>
            </div>
            <div class="product-footer">
              <div class="product-price">&yen;${item.price}</div>
            </div>
          `;
          itemElement.appendChild(linkElement);
          productsGrid.appendChild(itemElement);
        });
      } else {
        productsGrid.innerHTML = '<p>該当する商品はありません。</p>';
      }
    };

    conditionSelect.addEventListener("change", filterAndDisplayItems);
  }
};

window.addEventListener("turbo:load", search);
window.addEventListener("turbo:render", search); 