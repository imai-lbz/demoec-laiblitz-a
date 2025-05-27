const scroll = () => {
  const sidebar = document.getElementById("search-sidebar");
  const container = document.querySelector(".display-flex-content");
  if (!sidebar || !container) return;

  const offset = 120;
  const originalTop = sidebar.getBoundingClientRect().top + window.scrollY;

  window.addEventListener("scroll", () => {
    const scrollY = window.scrollY;

    // containerとsidebarの高さ取得
    const containerHeight = container.offsetHeight;
    const sidebarHeight = sidebar.offsetHeight;

    // 許容できる最大のmargin-top
    const maxMargin = containerHeight - sidebarHeight;

    // 実際に適用するmargin
    const margin = Math.min(Math.max(0, scrollY - originalTop + offset), maxMargin);
    sidebar.style.marginTop = `${margin}px`;
  });
};
window.addEventListener("turbo:load", scroll);
window.addEventListener("turbo:render", scroll);