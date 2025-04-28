#!/bin/bash

show_help() {
  echo "Usage: siri_come_back [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -h, --help                 Show this help message"
  echo ""
  echo "This script re-enables services that were disabled by siri_be_gone.sh"
  echo ""
  echo "Examples:"
  echo "  ./siri_come_back.sh        # Bring Siri back from vacation"
  echo ""
  echo "Note: You may need to restart your Mac for changes to take full effect."
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  -h | --help)
    show_help
    exit 0
    ;;
  *)
    echo "Unknown option: $1"
    show_help
    exit 1
    ;;
  esac
done

echo "🚀 Welcome to siri-come-back! 🚀"
echo "Bringing Siri back from her vacation..."
echo "This might take a moment. Siri has a lot of luggage..."

if [ -d "$HOME/.siri_be_gone" ]; then
  if [ -f "$HOME/.siri_be_gone/disabled_nuke.txt" ]; then
    SERVICES_FILE="$HOME/.siri_be_gone/disabled_nuke.txt"
    echo "Found record of nuke mode services to re-enable."
  elif [ -f "$HOME/.siri_be_gone/disabled_safe.txt" ]; then
    SERVICES_FILE="$HOME/.siri_be_gone/disabled_safe.txt"
    echo "Found record of safe mode services to re-enable."
  else
    echo "No record of disabled services found. Will attempt to re-enable common services."
    SERVICES_FILE=""
  fi
else
  echo "No record of disabled services found. Will attempt to re-enable common services."
  SERVICES_FILE=""
fi

common_system_services=(
  'com.apple.analyticsd'
  'com.apple.audioanalyticsd'
  'com.apple.ecosystemanalyticsd'
  'com.apple.wifianalyticsd'
)

common_user_services=(
  'com.apple.ap.adprivacyd'
  'com.apple.ap.promotedcontentd'
  'com.apple.assistant_service'
  'com.apple.assistantd'
  'com.apple.assistant_cdmd'
  'com.apple.BiomeAgent'
  'com.apple.biomesyncd'
  'com.apple.ContextStoreAgent'
  'com.apple.corespeechd'
  'com.apple.duetexpertd'
  'com.apple.geoanalyticsd'
  'com.apple.inputanalyticsd'
  'com.apple.intelligenceflowd'
  'com.apple.intelligencecontextd'
  'com.apple.intelligenceplatformd'
  'com.apple.knowledge-agent'
  'com.apple.knowledgeconstructiond'
  'com.apple.mediaanalysisd'
  'com.apple.naturallanguaged'
  'com.apple.parsec-fbf'
  'com.apple.parsecd'
  'com.apple.photoanalysisd'
  'com.apple.siriactionsd'
  'com.apple.Siri.agent'
  'com.apple.siriinferenced'
  'com.apple.sirittsd'
  'com.apple.SiriTTSTrainingAgent'
  'com.apple.siriknowledged'
  'com.apple.suggestd'
  'com.apple.tipsd'
  'com.apple.triald'
  'com.apple.UsageTrackingAgent'
)

enable_service() {
  local service="$1"
  echo "Re-enabling $service..."

  if [ "$service" == "com.apple.geod" ]; then
    sudo launchctl enable user/205/${service} 2>/dev/null
    echo "Enabled special service: $service"
    return
  fi

  if [ -f "/System/Library/LaunchDaemons/${service}.plist" ]; then
    sudo launchctl enable system/${service} 2>/dev/null
    sudo launchctl bootstrap system "/System/Library/LaunchDaemons/${service}.plist" 2>/dev/null || echo "Could not bootstrap: $service"
    return
  fi

  if [ -f "/System/Library/LaunchAgents/${service}.plist" ]; then
    launchctl enable gui/501/${service} 2>/dev/null
    launchctl bootstrap gui/501 "/System/Library/LaunchAgents/${service}.plist" 2>/dev/null || echo "Could not bootstrap: $service"
    return
  fi

  if [ -f "/Library/LaunchAgents/${service}.plist" ]; then
    launchctl enable gui/501/${service} 2>/dev/null
    launchctl bootstrap gui/501 "/Library/LaunchAgents/${service}.plist" 2>/dev/null || echo "Could not bootstrap: $service"
    return
  fi

  if [ -f "$HOME/Library/LaunchAgents/${service}.plist" ]; then
    launchctl enable gui/501/${service} 2>/dev/null
    launchctl bootstrap gui/501 "$HOME/Library/LaunchAgents/${service}.plist" 2>/dev/null || echo "Could not bootstrap: $service"
    return
  fi

  echo "Could not find plist for: $service"

  if [[ "$service" == *"daemon"* ]] || [[ "$service" == *"d" ]]; then
    sudo launchctl enable system/${service} 2>/dev/null
  else
    launchctl enable gui/501/${service} 2>/dev/null
  fi
}

# Re-enable services
if [ -n "$SERVICES_FILE" ]; then
  # Read services from file
  while IFS= read -r service; do
    # Skip empty lines
    if [ -n "$service" ]; then
      enable_service "$service"
    fi
  done <"$SERVICES_FILE"

  # Clean up the file after re-enabling
  rm "$SERVICES_FILE"
  echo "Removed record of disabled services."
else
  # Re-enable common services
  echo "Re-enabling common system services..."
  for service in "${common_system_services[@]}"; do
    enable_service "$service"
  done

  echo "Re-enabling common user services..."
  for service in "${common_user_services[@]}"; do
    enable_service "$service"
  done

  echo "Re-enabling geod service..."
  sudo launchctl enable user/205/com.apple.geod 2>/dev/null
fi

echo "✅ Rollback completed! Siri is back from vacation."
echo "Please restart your Mac for changes to take full effect."
