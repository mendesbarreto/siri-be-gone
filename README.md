# siri-be-gone

A macOS utility to selectively disable Siri, analytics, and other non-essential Apple services.

## Overview

`siri-be-gone` gives you control over the numerous background services running on your Mac. It allows you to disable Siri-related services, analytics collectors, and other non-essential processes that may:

- Consume system resources
- Collect data about your usage
- Run in the background without your knowledge
- Affect battery life and performance

The tool offers two modes:
- **Safe Mode**: Disables only non-essential services like Siri and analytics
- **Nuke Mode**: Disables all possible services (use with caution)

## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/siri-be-gone.git

# Navigate to the directory
cd siri-be-gone

# Make the script executable
chmod +x siri_be_gone.sh
```

## Usage

```bash
# Show help information
./siri_be_gone.sh --help

# Run in safe mode (recommended for most users)
./siri_be_gone.sh --disable-type safe

# Run in nuke mode (advanced users only)
./siri_be_gone.sh -d nuke
```

## What It Does

This script uses `launchctl` to disable various macOS services:

### Safe Mode Disables:
- Siri and voice assistant services
- Analytics collection services
- Machine learning and intelligence services
- Ad-related services

### Nuke Mode Disables:
- All services from Safe Mode
- Various system services
- Cloud-related services
- Location services
- And many more

## Service Descriptions

The script includes detailed descriptions of each service it can disable. Here are some examples:

| Service | Description |
|---------|-------------|
| com.apple.Siri.agent | User-facing Siri agent |
| com.apple.analyticsd | Collects system analytics data and sends to Apple |
| com.apple.suggestd | Provides suggestions in Spotlight and other areas |
| com.apple.photoanalysisd | Analyzes photos for facial recognition and categorization |

## Caution

- **Always run in safe mode first** before trying nuke mode
- Some services are essential for normal macOS operation
- Disabling certain services may affect functionality of some Apple features
- Changes take full effect after restarting your Mac
- To restore services, you may need to reset your Mac's launch services or reinstall macOS

## Compatibility

Tested on:
- macOS Ventura (13.x)
- macOS Sonoma (14.x)

May work on other versions but use at your own risk.

## Restoring Services

If you need to restore services:

```bash
# For user services
launchctl enable gui/501/[service-name]
launchctl bootstrap gui/501 /System/Library/LaunchAgents/[service-name].plist

# For system services
sudo launchctl enable system/[service-name]
sudo launchctl bootstrap system /System/Library/LaunchDaemons/[service-name].plist
```

## Disclaimer

This tool is provided for educational purposes only. Use at your own risk. The author is not responsible for any issues that may arise from using this script, including but not limited to system instability, data loss, or reduced functionality.

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
