const search = () => {
  const items = gon.items;
  const categories = gon.categories
  const conditionDropdown = document.getElementById("item-condition-select");
  const productsGrid = document.getElementById("products-grid");
  const slider = document.getElementById('slider');
  const rangeDisplay = document.getElementById('range');
  if (!conditionDropdown || !productsGrid) return;


  const isSameItemList = (currentElements, newItems) => {
    const currentIds = Array.from(currentElements)
      .map(el => parseInt(el.id, 10));
    const newIds = newItems.map(item => item.id);

    if (currentIds.length !== newIds.length) return false;

    if (currentIds.every((id, i) => id === newIds[i])) {
      console.log("問題なし")
    }else{
      console.log("aaa",currentIds)
      console.log(newIds)
    }

    return currentIds.every((id, i) => id === newIds[i]);
  };

  const updatePriceRangeView = (min, max) => {
    if (rangeDisplay) {
      rangeDisplay.textContent = `¥${min.toLocaleString()} 〜 ¥${max.toLocaleString()}`;
    }
  };


  const setSlider = () => {
    const prices = items.map(item => item.price);
    const minPrice = Math.min(...prices);
    const maxPrice = Math.max(...prices);
    
    noUiSlider.create(slider, {
      start: [minPrice, maxPrice],
      connect: true,
      range: {
        'min': minPrice,
        'max': maxPrice
      },
      tooltips: true, // 吹き出し表示
      format: {
        to: value => Math.round(value),
        from: value => Number(value)
      }
    });
    const rangeDisplay = document.getElementById('range');
    slider.noUiSlider.on('update', function(values) {
      const [minPrice, maxPrice] = values.map(v => parseInt(v, 10));
      updatePriceRangeView(minPrice, maxPrice); // ← 追加
      filterAndDisplayItems()
    });
  }

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
    let favoriteFrameHtml = '';

    // ユーザーがログインしていて、かつ管理者でないときだけハートを表示
    if (gon.current_user && !gon.current_user.admin_flag) {
      favoriteFrameHtml = `
        <turbo-frame id="favorite_item_${item.id}" src="/items/${item.id}/favorite_frame">
          <div class="loading">♡ 読み込み中</div>
        </turbo-frame>
      `;
    }

    return `
        ${favoriteFrameHtml}
        <a class="product-card" href="/items/${item.id}">
          <div class="product-image-container">
            <img class="product-image" src="${item.image_url}" alt="${item.name}">
            ${item.is_sold_out ? '<div class="sold-out-badge"><span>在庫なし</span></div>' : ''}
          </div>
          <div class="product-content">
            <div class="product-category">${item.category_name}</div>
            <h3 class="product-name">${item.name}</h3>
          </div>
          <div class="product-footer">
            <div class="product-price">¥${item.price}</div>
          </div>
        </a>
    `;
  };


  const filterAndDisplayItems = () => {
    let filteredItems = items;
    const [minPrice, maxPrice] = slider.noUiSlider.get().map(value => parseInt(value, 10));

    filteredItems = filterCategory(filteredItems)
    filteredItems = filterCondition(filteredItems,conditionDropdown.value);
    filteredItems = filterMinPrice(filteredItems,minPrice);
    filteredItems = filterMaxPrice(filteredItems,maxPrice);

    const currentElements = productsGrid.querySelectorAll('.product-card-container');

    if (isSameItemList(currentElements, filteredItems)) {
      return;
    }

    productsGrid.innerHTML = '';



    if (filteredItems.length > 0) {
      filteredItems.forEach(item => {
        const itemElement = document.createElement('div');
        itemElement.classList.add('product-card-container');
        itemElement.id = `${item.id}`;

        itemElement.innerHTML = buildHtml(item);
        productsGrid.appendChild(itemElement);

      });
    } else {
      productsGrid.innerHTML = '<p>該当する商品はありません。</p>';
    }
  };
  
  setSlider()

  conditionDropdown.addEventListener("change", filterAndDisplayItems);

};

window.addEventListener("turbo:load", search);
window.addEventListener("turbo:render", search); 