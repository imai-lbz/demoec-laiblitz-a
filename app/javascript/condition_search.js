const search = () => {
  const items = gon.items;
  const conditionDropdown = document.getElementById("item-condition-select");
  const priceDropdown = document.getElementById("item-price-select");
  const productsGrid = document.getElementById("products-grid");
  if (!conditionDropdown || !productsGrid || !priceDropdown) return;

  const filterCondition = (items,selectedConditionId) => {
    let filteredItems = [];
    if (selectedConditionId === "") {
      filteredItems = items;
    } else {
      filteredItems = items.filter(item => {
        return item.condition_id.toString() === selectedConditionId;
      });
    }
    return filteredItems;
  }

  const filterPrice = (items,price) => {
    let filteredItems = [];
    if (price === "") {
      filteredItems = items;
    } else {
      filteredItems = items.filter(item => {
        return item.price < price;
      });
    }
    return filteredItems;
  }

  const buildHtml = (item) => {
    let soldOutBadgeHtml = '';
        if (item.is_sold_out) {
          soldOutBadgeHtml = '<div class="sold-out-badge">在庫なし</div>';
        }
    let html  = `
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
        return html
  }

  const filterAndDisplayItems = () => {
    productsGrid.innerHTML = '';
    const selectedConditionId = conditionDropdown.value;
    console.log(priceDropdown.value)

    let filteredItems = filterCondition(items,selectedConditionId);
    filteredItems = filterPrice(filteredItems,priceDropdown.value);


    if (filteredItems.length > 0) {
      filteredItems.forEach(item => {
        const itemElement = document.createElement('div');
        itemElement.classList.add('product-item');
        const linkElement = document.createElement('a');
        linkElement.href = `/items/${item.id}`; 
        linkElement.classList.add('product-item-link');
        linkElement.innerHTML = buildHtml(item)
        itemElement.appendChild(linkElement);
        productsGrid.appendChild(itemElement);
      });
    } else {
      productsGrid.innerHTML = '<p>該当する商品はありません。</p>';
    }
  };

  conditionDropdown.addEventListener("change", filterAndDisplayItems);
  priceDropdown.addEventListener("change", filterAndDisplayItems);

};

window.addEventListener("turbo:load", search);
window.addEventListener("turbo:render", search); 