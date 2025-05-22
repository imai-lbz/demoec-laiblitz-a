
const search = () => {
  const conditionSelect = document.getElementById("item-condition-select");
  const filterForm = document.getElementById("filter-form");
  if (conditionSelect && filterForm){
    conditionSelect.addEventListener("change", () => {
      filterForm.submit();
    });
  }
};

window.addEventListener("turbo:load", search);
window.addEventListener("turbo:render", search);