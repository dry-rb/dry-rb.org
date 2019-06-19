function switcher() {
  return document.getElementById('sidebar__version-switcher');
}

export default function switchVersion() {
  switcher().addEventListener('change', switchVersionHandler);
}

function switchVersionHandler() {
  window.document.location = switcher().value;
}
