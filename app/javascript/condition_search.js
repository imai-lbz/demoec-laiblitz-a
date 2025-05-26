const search = () => {
  const items = gon.items;
  const categories = gon.categories
  const conditionDropdown = document.getElementById("item-condition-select");
  const priceMinDropdown = document.getElementById("item-min-price-select");
  const priceMaxDropdown = document.getElementById("item-max-price-select");
  const productsGrid = document.getElementById("products-grid");
  if (!conditionDropdown || !productsGrid || !priceMinDropdown || !priceMaxDropdown) return;

  const categoryLinks = document.querySelectorAll(".category-link");
  const selectedCategoriesArea = document.getElementById("selected-categories");
  categoryLinks.forEach(link => {
    link.addEventListener("click", (event) => {
      event.preventDefault();
      const selectedCategoryId = link.id.match(/\d+$/)[0];
      const alreadyExists = document.querySelector(`.selected-category[data-category-id='${selectedCategoryId}']`);
      if (alreadyExists) return;
      createCategoryBtn(selectedCategoryId)
      filterAndDisplayItems()
    });
  });

  const getSelectedCategoryIds = () => {
    const selectedCategoryDivs = document.querySelectorAll(".selected-category");
    return Array.from(selectedCategoryDivs).map(div => div.getAttribute("data-category-id"));
  };


  const createCategoryBtn = (categoryId) => {
    const categoryItem = document.createElement("div");
    categoryItem.className = "selected-category";
    categoryItem.setAttribute("data-category-id", categoryId);

    const category = categories.find(cat => cat.id === parseInt(categoryId, 10));
    categoryItem.innerHTML = `
      ${category.name}
      <button data-remove-id="${categoryId}">×</button>
    `;

    selectedCategoriesArea.appendChild(categoryItem);

    document.querySelectorAll(".selected-category button").forEach(btn => {
      btn.addEventListener("click", (e) => {
        const idToRemove = e.target.dataset.removeId;
        const target = document.querySelector(`.selected-category[data-category-id='${idToRemove}']`);
        if (target) {
          target.remove();
          filterAndDisplayItems()
        }
      });
    });
  }

  const filterCategory = (items) => {
    const selectedCategoryIds  = getSelectedCategoryIds()
    console.log(selectedCategoryIds)
    if (selectedCategoryIds.length === 0) {
      return items; // カテゴリが選択されていなければ全件返す
    }
    return items.filter(item =>
      selectedCategoryIds.includes(item.category_id.toString())
    );
  }

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

  const filterMinPrice = (items,minPrice) => {
    let filteredItems = [];
    if (minPrice === "") {
      filteredItems = items;
    } else {
      minPrice = parseInt(minPrice, 10);
      filteredItems = items.filter(item => {
        return item.price >= minPrice;
      });
    }
    return filteredItems;
  }

  const filterMaxPrice = (items,maxPrice) => {
    let filteredItems = [];
    if (maxPrice === "") {
      filteredItems = items;
    } else {
      maxPrice = parseInt(maxPrice, 10);
      filteredItems = items.filter(item => {
        return item.price <= maxPrice;
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

    let filteredItems = items;

    filteredItems = filterCategory(filteredItems)
    filteredItems = filterCondition(filteredItems,conditionDropdown.value);
    filteredItems = filterMinPrice(filteredItems,priceMinDropdown.value);
    filteredItems = filterMaxPrice(filteredItems,priceMaxDropdown.value);

    console.log("最終的に絞り込まれた商品データ:", filteredItems);

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
  priceMinDropdown.addEventListener("change", filterAndDisplayItems);
  priceMaxDropdown.addEventListener("change", filterAndDisplayItems);

};

window.addEventListener("turbo:load", search);
window.addEventListener("turbo:render", search); 