# OmniHermes AI Core

OmniHermes AI Core is a powerful, unified Home Assistant add-on that seamlessly integrates **OmniRoute** (a local AI gateway) and the **Hermes Agent** (an autonomous AI agent). This complete package runs directly on your Home Assistant OS, providing persistent workspaces, load-balanced API routing, and direct Git integration.

## Features

*   **Universal Architecture Support:** Fully compatible with `aarch64` (Raspberry Pi), `amd64`, `armhf`, `armv7`, and `i386`.
*   **OmniRoute Integration:** Intercepts, routes, and load-balances Hermes' API calls, saving you from rate limits and providing auto-fallback mechanisms.
*   **Persistent Workspaces:** Automatically creates isolated workspaces (e.g., `home_assistant_workspace` and custom project folders) directly in Home Assistant's `/data` directory. These survive updates and restarts.
*   **Git Integration:** Automatically configures your global Git credentials using a provided token, allowing the Hermes Agent to autonomously clone, commit, and push to GitHub or GitLab without manual authentication.

## Installation

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Famiralbert%2FHA-App-OmniHermes-AI-Core)

**Method 1: One-Click Install**
1. Click the button above to automatically add this repository to your Home Assistant instance.
2. Click **Install** on the OmniHermes AI Core add-on page.

**Method 2: Manual Install**
1. Navigate to **Settings** > **Add-ons** > **Add-on Store** in your Home Assistant.
2. Click the three dots in the top right corner and select **Repositories**.
3. Add `https://github.com/amiralbert/HA-App-OmniHermes-AI-Core` and click Add.
4. Close the dialog, find **OmniHermes AI Core** in the store, and click Install.

## Configuration

The following options can be set directly in the Home Assistant UI:

*   **Start Mode:** Choose between `dashboard` or `gateway`.
*   **OpenRouter API Key:** Your API key for OpenRouter (automatically loaded into OmniRoute). 
    *   👉 [Create your OpenRouter API key here](https://openrouter.ai/keys).
*   **Git Credentials:** Enter your Username, Email, and Token to grant Hermes autonomous push/pull rights.
    *   **GitHub:** 👉 [Generate a Personal Access Token here](https://github.com/settings/tokens) (requires the `repo` scope).
    *   **GitLab:** 👉 [Generate a Personal Access Token here](https://gitlab.com/-/profile/personal_access_tokens) (requires the `write_repository` scope).
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


1