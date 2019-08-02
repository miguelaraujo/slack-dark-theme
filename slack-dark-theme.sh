#!/usr/bin/env bash

JS="
// Load app wrapper
document.addEventListener('DOMContentLoaded', function() {
  // Fetch CSS
  const cssPath = 'https://raw.githubusercontent.com/miguelaraujo/slack-dark-theme/master/dark_theme.css';
  let cssPromise = fetch(cssPath).then((response) => response.text());

  // Insert a style tag into the wrapper view
  cssPromise.then((css) => {
    let s = document.createElement('style');
    s.type = 'text/css';
    s.innerHTML = css;
    document.head.appendChild(s);
  });
});"

SLACK_RESOURCES_DIR="/usr/lib/slack/resources"
SLACK_FILE_PATH="${SLACK_RESOURCES_DIR}/app.asar.unpacked/dist/ssb-interop.bundle.js"

echo "Updating Slack's theme... "

sudo npx asar extract ${SLACK_RESOURCES_DIR}/app.asar ${SLACK_RESOURCES_DIR}/app.asar.unpacked
sudo tee -a "${SLACK_FILE_PATH}" > /dev/null <<< "$JS"
sudo npx asar pack ${SLACK_RESOURCES_DIR}/app.asar.unpacked ${SLACK_RESOURCES_DIR}/app.asar

echo "Successfuly updated Slack to use the dark theme."
