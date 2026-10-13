# OmniHermes AI Core

OmniHermes AI Core is a powerful, unified Home Assistant add-on that seamlessly integrates **OmniRoute** (a local AI gateway) and the **Hermes Agent** (an autonomous AI agent). This complete package runs directly on your Home Assistant OS, providing persistent workspaces, load-balanced API routing, and direct Git integration.

## Features

*   **Universal Architecture Support:** Fully compatible with `aarch64` (Raspberry Pi), `amd64`, `armhf`, `armv7`, and `i386`.
*   **OmniRoute Integration:** Intercepts, routes, and load-balances Hermes' API calls, saving you from rate limits and providing auto-fallback mechanisms.
*   **Persistent Workspaces:** Automatically creates isolated workspaces (e.g., `home_assistant_workspace` and custom project folders) directly in Home Assistant's `/data` directory. These survive updates and restarts.
*   **Git Integration:** Automatically configures your global Git credentials using a provided token, allowing the Hermes Agent to autonomously clone, commit, and push to GitHub or GitLab without manual authentication.

## Installation

1.  Copy the `omnihermes_ai_core` folder into your Home Assistant `/addons` directory.
2.  Navigate to **Settings** > **Add-ons** > **Add-on Store**.
3.  Click the three dots in the top right corner and select **Check for updates**.
4.  Locate **OmniHermes AI Core** under your Local add-ons and click Install.

## Configuration

The following options can be set directly in the Home Assistant UI:

*   **Start Mode:** Choose between `openrouter`, `dashboard`, or `gateway`.
*   **OpenRouter API Key:** Your API key for OpenRouter (used if start mode is openrouter).
*   **Git Credentials:** Enter your Username, Email, and Token to grant Hermes autonomous push/pull rights.
*   **Hermes Workspaces:** A comma-separated list of project folders you want the add-on to generate persistently.

## Usage

*   **Hermes Dashboard:** `http://<your-ha-ip>:9119`
*   **OmniRoute Gateway:** `http://<your-ha-ip>:20128`

## Support
If you find this add-on helpful, you can support my work here:

[![Buy Me A Coffee](https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png)](https://buymeacoffee.com/Aalbert)

## License

MIT License

Copyright (c) 2026 Amir Alexander Albert <amir.a.albert@gmail.com>
