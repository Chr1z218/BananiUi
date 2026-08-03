# BananiUI Privacy and Network Disclosure

BananiUI does not intentionally collect or transmit:

- Roblox usernames or display names
- Roblox user IDs
- Place IDs or game IDs for analytics
- Discord invite information
- Configuration names or values
- Usage events
- Personal contact information

The public build removes the previous analytics reporter, collection endpoint, heartbeat request, remote prompt helper, and remote Discord boost helper.

## Remaining network or asset access

The UI may still retrieve documented visual dependencies:

- Rayfield icon definitions from the SiriusSoftwareLtd/Rayfield GitHub repository
- Rayfield image assets from the SiriusSoftwareLtd/Rayfield GitHub repository
- The Roblox UI asset used to construct the interface
- A Discord local RPC URL only when a developer explicitly enables Discord integration

These are UI dependencies or explicitly enabled features, not hidden analytics.

## Protecting your information

Do not put API keys, passwords, private webhooks, personal email addresses, authentication tokens, or private repository credentials inside `source.lua`, examples, configuration defaults, or raw GitHub URLs. Public source can always be read by users.
