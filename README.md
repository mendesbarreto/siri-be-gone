# WARNING PROJECT NOT READY YET

# Siri Be Gone

A macOS utility to disable Siri and related telemetry services for enhanced privacy.

## 🚀 Overview

`siri-be-gone` is a command-line tool that allows you to disable Siri and various analytics services on your Mac. It offers two modes of operation:

- **Safe Mode**: Disables only non-essential Siri and analytics services
- **Nuke Mode**: Disables all possible services (may affect some functionality)

And when you want Siri back, there's a companion script to restore everything.

## 📋 Requirements

- macOS 10.15 (Catalina) or newer
- Administrator privileges (for disabling system services)

## 🔧 Installation

1. Clone this repository or download the scripts:

```bash
git clone https://github.com/yourusername/siri-be-gone.git
cd siri-be-gone
```

2. Make the scripts executable:

```bash
chmod +x siri_be_gone.sh
chmod +x siri_come_back.sh
```

## 🔍 Usage

### Disabling Siri and Analytics

To disable Siri and related services, use the `siri_be_gone.sh` script with one of the following options:

```bash
# Safe mode - disables only non-essential services
./siri_be_gone.sh --disable-type safe

# Nuke mode - disables all possible services
./siri_be_gone.sh --disable-type nuke
```

### Re-enabling Services

To bring Siri back from vacation, use the companion script:

```bash
./siri_come_back.sh
```

### Help

For more information about available options:

```bash
./siri_be_gone.sh --help
./siri_come_back.sh --help
```

## 🔒 What Gets Disabled?

### Safe Mode

Safe mode disables non-essential services including:

- Siri voice assistant
- Speech recognition
- Various analytics and telemetry services
- Suggestion services

### Nuke Mode

Nuke mode disables everything in safe mode plus:

- Location services
- iCloud-related services
- Additional analytics
- Various background services
- And much more...

## ⚠️ Warnings

- **Restart Required**: After running either script, restart your Mac for changes to take full effect.
- **Functionality Impact**: Nuke mode may affect some Mac functionality that relies on the disabled services.
- **Updates**: macOS updates may re-enable some services. Run the script again after major updates.
- **Reversibility**: All changes can be reversed using the `siri_come_back.sh` script.

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🛠️ Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
