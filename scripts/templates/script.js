const COPY_ICON =
  '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="9" y="9" width="13" height="13" rx="2"></rect><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path></svg>';
const CHECK_ICON =
  '<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>';

document.querySelectorAll("pre").forEach((pre) => {
  const code = pre.querySelector("code");
  if (!code) return;

  const button = document.createElement("button");
  button.type = "button";
  button.className = "copy-btn";
  button.title = "Copy";
  button.setAttribute("aria-label", "Copy to clipboard");
  button.innerHTML = COPY_ICON;

  button.addEventListener("click", () => {
    navigator.clipboard.writeText(code.textContent).then(() => {
      button.innerHTML = CHECK_ICON;
      button.classList.add("copied");
      setTimeout(() => {
        button.innerHTML = COPY_ICON;
        button.classList.remove("copied");
      }, 1500);
    });
  });

  pre.appendChild(button);
});
