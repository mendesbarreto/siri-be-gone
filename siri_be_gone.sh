#!/bin/bash

show_help() {
  echo "Usage: siri_be_gone [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -d, --disable-type TYPE    Tell Siri to take a vacation (safe) or send her to Mars (nuke)"
  echo "  -h, --help                 Show this help message"
  echo ""
  echo "Disable Types:"
  echo "  safe    The 'I still want my Mac to work tomorrow' option"
  echo "  nuke    The 'Siri, I've booked you a one-way trip to Mars' option"
  echo ""
  echo "Examples:"
  echo "  siri_be_gone --disable-type safe   # For the cautious privacy enthusiast"
  echo "  siri_be_gone -d nuke               # For the tinfoil hat power user"
  echo ""
  echo "Warning: Apple engineers shed a single tear every time you run this script."
}

DISABLE_TYPE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
  -d | --disable-type)
    DISABLE_TYPE="$2"
    shift 2
    ;;
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

if [ -z "$DISABLE_TYPE" ]; then
  echo "Error: No disable type specified."
  show_help
  exit 1
fi

if [ "$DISABLE_TYPE" != "safe" ] && [ "$DISABLE_TYPE" != "nuke" ]; then
  echo "Error: Invalid disable type. Use 'safe' or 'nuke'."
  show_help
  exit 1
fi

declare -A userServices
userServices=(
  ['com.apple.accessibility.MotionTrackingAgent']="Tracks motion for accessibility features"
  ['com.apple.accessibility.axassetsd']="Manages accessibility assets"
  ['com.apple.ap.adprivacyd']="Ad privacy service that collects data for personalized ads"
  ['com.apple.ap.promotedcontentd']="Handles promoted content and ads in Apple apps"
  ['com.apple.assistant_service']="Background service for Siri assistant"
  ['com.apple.assistantd']="Main Siri assistant daemon"
  ['com.apple.assistant_cdmd']="Command and control service for Siri"
  ['com.apple.avconferenced']="Handles audio/video conferencing"
  ['com.apple.BiomeAgent']="Collects and processes user behavior data for system intelligence"
  ['com.apple.biomesyncd']="Syncs Biome data (user behavior patterns) across devices"
  ['com.apple.calaccessd']="Manages calendar access permissions"
  ['com.apple.CallHistoryPluginHelper']="Manages call history for FaceTime and Phone"
  ['com.apple.chronod']="Manages time-based events and notifications"
  ['com.apple.cloudd']="Handles iCloud service connections"
  ['com.apple.cloudpaird']="Pairs devices for iCloud services"
  ['com.apple.cloudphotod']="Manages iCloud Photos synchronization"
  ['com.apple.CloudSettingsSyncAgent']="Syncs system settings through iCloud"
  ['com.apple.CommCenter-osx']="Manages cellular and network communications"
  ['com.apple.ContextStoreAgent']="Stores contextual data about user activities for Siri suggestions"
  ['com.apple.CoreLocationAgent']="Manages location services for apps"
  ['com.apple.corespeechd']="Handles speech recognition for Siri and dictation"
  ['com.apple.dataaccess.dataaccessd']="Manages data access for contacts, calendars, etc."
  ['com.apple.duetexpertd']="Part of the Intelligent Tracking system for app suggestions"
  ['com.apple.familycircled']="Manages Family Sharing features"
  ['com.apple.familycontrols.useragent']="Manages Screen Time and parental controls"
  ['com.apple.familynotificationd']="Handles notifications for Family Sharing"
  ['com.apple.financed']="Manages Apple Card and Apple Pay features"
  ['com.apple.findmy.findmylocateagent']="Locates devices for Find My service"
  ['com.apple.followupd']="Manages follow-up suggestions for Siri"
  ['com.apple.gamed']="Handles Game Center functionality"
  ['com.apple.generativeexperiencesd']="Manages AI-based features like text generation"
  ['com.apple.geoanalyticsd']="Analyzes location data for system services"
  ['com.apple.geodMachServiceBridge']="Bridge for location services"
  ['com.apple.helpd']="Manages Help system content"
  ['com.apple.homed']="Controls HomeKit functionality"
  ['com.apple.icloud.fmfd']="Find My Mac/iPhone daemon"
  ['com.apple.iCloudNotificationAgent']="Handles iCloud notifications"
  ['com.apple.icloudmailagent']="Manages iCloud mail synchronization"
  ['com.apple.iCloudUserNotifications']="Manages user notifications for iCloud"
  ['com.apple.icloud.searchpartyuseragent']="Helps locate offline devices via crowd-sourcing"
  ['com.apple.imagent']="Handles iMessage and FaceTime connectivity"
  ['com.apple.imautomatichistorydeletionagent']="Auto-deletes old iMessage history"
  ['com.apple.imtransferagent']="Manages file transfers in iMessage"
  ['com.apple.inputanalyticsd']="Collects data about keyboard and input usage"
  ['com.apple.intelligenceflowd']="Processes data for Siri intelligence features"
  ['com.apple.intelligencecontextd']="Manages contextual data for Siri intelligence"
  ['com.apple.intelligenceplatformd']="Core service for Apple's machine learning features"
  ['com.apple.itunescloudd']="Manages iTunes and Music app cloud features"
  ['com.apple.knowledge-agent']="Builds knowledge database for Siri"
  ['com.apple.knowledgeconstructiond']="Constructs knowledge graphs for Siri"
  ['com.apple.ManagedClientAgent.enrollagent']="Handles device enrollment for MDM"
  ['com.apple.Maps.pushdaemon']="Handles push notifications for Maps"
  ['com.apple.Maps.mapssyncd']="Syncs Maps data across devices"
  ['com.apple.maps.destinationd']="Manages frequently visited locations in Maps"
  ['com.apple.mediaanalysisd']="Analyzes media files for Photos features like Memories"
  ['com.apple.mediastream.mstreamd']="Handles media streaming"
  ['com.apple.naturallanguaged']="Processes natural language for Siri and text analysis"
  ['com.apple.navd']="Navigation service for Maps"
  ['com.apple.newsd']="Manages Apple News content and notifications"
  ['com.apple.parsec-fbf']="Part of Apple's machine learning system"
  ['com.apple.parsecd']="Processes data for Siri and system intelligence"
  ['com.apple.passd']="Manages Apple Wallet passes"
  ['com.apple.photoanalysisd']="Analyzes photos for facial recognition and categorization"
  ['com.apple.photolibraryd']="Manages the Photos library"
  ['com.apple.progressd']="Tracks progress of system tasks"
  ['com.apple.protectedcloudstorage.protectedcloudkeysyncing']="Syncs encrypted keys for iCloud"
  ['com.apple.quicklook']="Generates previews for files"
  ['com.apple.quicklook.ui.helper']="Helper for QuickLook UI"
  ['com.apple.quicklook.ThumbnailsAgent']="Generates thumbnails for QuickLook"
  ['com.apple.rapportd']="Manages Handoff and Continuity features"
  ['com.apple.rapportd-user']="User-specific Handoff and Continuity features"
  ['com.apple.remindd']="Manages Reminders app data"
  ['com.apple.replicatord']="Replicates data between devices"
  ['com.apple.routined']="Learns user routines for Siri suggestions"
  ['com.apple.screensharing.agent']="Handles screen sharing connections"
  ['com.apple.screensharing.menuextra']="Manages screen sharing menu bar item"
  ['com.apple.screensharing.MessagesAgent']="Handles screen sharing in Messages"
  ['com.apple.ScreenTimeAgent']="Manages Screen Time feature"
  ['com.apple.SSInvitationAgent']="Handles Screen Sharing invitations"
  ['com.apple.security.cloudkeychainproxy3']="Manages iCloud Keychain"
  ['com.apple.sharingd']="Handles AirDrop and sharing features"
  ['com.apple.sidecar-hid-relay']="Relays input for Sidecar feature"
  ['com.apple.sidecar-relay']="Manages Sidecar connections"
  ['com.apple.siriactionsd']="Handles Siri shortcut actions"
  ['com.apple.Siri.agent']="User-facing Siri agent"
  ['com.apple.siriinferenced']="Makes inferences based on user data for Siri"
  ['com.apple.sirittsd']="Text-to-speech service for Siri"
  ['com.apple.SiriTTSTrainingAgent']="Trains text-to-speech models for Siri"
  ['com.apple.macos.studentd']="Manages education features"
  ['com.apple.siriknowledged']="Manages Siri's knowledge database"
  ['com.apple.suggestd']="Provides suggestions in Spotlight and other areas"
  ['com.apple.tipsd']="Manages Tips app content"
  ['com.apple.telephonyutilities.callservicesd']="Manages phone call services"
  ['com.apple.TMHelperAgent']="Time Machine helper agent"
  ['com.apple.triald']="Collects usage data for Apple internal analysis"
  ['com.apple.universalaccessd']="Manages accessibility features"
  ['com.apple.UsageTrackingAgent']="Tracks app and feature usage"
  ['com.apple.videosubscriptionsd']="Manages video subscriptions like Apple TV+"
  ['com.apple.voicebankingd']="Manages voice banking for accessibility features"
  ['com.apple.watchlistd']="Manages watchlist for TV app"
  ['com.apple.weatherd']="Manages Weather app data and notifications"
)

declare -A systemServices
systemServices=(
  ['com.apple.analyticsd']="Collects system analytics data and sends to Apple"
  ['com.apple.audioanalyticsd']="Analyzes audio data for Siri and system features"
  ['com.apple.backupd']="Handles Time Machine backups"
  ['com.apple.backupd-helper']="Helper for Time Machine backups"
  ['com.apple.biomed']="Manages health and biometric data"
  ['com.apple.cloudd']="System-level iCloud service"
  ['com.apple.coreduetd']="Manages app predictions and suggestions"
  ['com.apple.dhcp6d']="Handles IPv6 DHCP connections"
  ['com.apple.ecosystemanalyticsd']="Collects data about device ecosystem interactions"
  ['com.apple.familycontrols']="System-level parental controls"
  ['com.apple.findmymac']="Find My Mac service"
  ['com.apple.findmymacmessenger']="Messaging service for Find My Mac"
  ['com.apple.findmy.findmybeaconingd']="Bluetooth beaconing for Find My network"
  ['com.apple.ftp-proxy']="Handles FTP connections through the firewall"
  ['com.apple.GameController.gamecontrollerd']="Manages game controller connections"
  ['com.apple.icloud.findmydeviced']="System service for Find My"
  ['com.apple.icloud.searchpartyd']="Helps locate offline devices"
  ['com.apple.locationd']="Core location service"
  ['com.apple.ManagedClient.cloudconfigurationd']="Manages cloud configuration for managed devices"
  ['com.apple.modelmanagerd']="Manages machine learning models"
  ['com.apple.netbiosd']="Handles NetBIOS name resolution"
  ['com.apple.rapportd']="System-level Handoff service"
  ['com.apple.screensharing']="System screen sharing service"
  ['com.apple.triald.system']="System-level analytics collection"
  ['com.apple.wifianalyticsd']="Collects and sends WiFi analytics data to Apple"
)

safeUserServices=(
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

safeSystemServices=(
  'com.apple.analyticsd'
  'com.apple.audioanalyticsd'
  'com.apple.ecosystemanalyticsd'
  'com.apple.wifianalyticsd'
)

disable_services() {
  local services=("$@")
  for service in "${services[@]}"; do
    echo "Disabling $service: ${userServices[$service]:-${systemServices[$service]}}"
    if [[ "$service" == com.apple.* ]]; then
      if [[ " ${!systemServices[@]} " =~ " $service " ]]; then
        sudo launchctl bootout system/${service} 2>/dev/null || echo "Service not running: $service"
        sudo launchctl disable system/${service} 2>/dev/null || echo "Failed to disable: $service"
      else
        launchctl bootout gui/501/${service} 2>/dev/null || echo "Service not running: $service"
        launchctl disable gui/501/${service} 2>/dev/null || echo "Failed to disable: $service"
      fi
    fi
  done
}

echo "Running siri-be-gone in $DISABLE_TYPE mode..."
if [ "$DISABLE_TYPE" == "safe" ]; then
  echo "Safe mode: Disabling only non-essential Siri and analytics services..."
  disable_services "${safeUserServices[@]}"
  disable_services "${safeSystemServices[@]}"
elif [ "$DISABLE_TYPE" == "nuke" ]; then
  echo "Nuke mode: Disabling all possible services..."
  disable_services "${!userServices[@]}"
  disable_services "${!systemServices[@]}"

  echo "Disabling geod service..."
  sudo launchctl bootout user/205/com.apple.geod 2>/dev/null || echo "Service not running: com.apple.geod"
  sudo launchctl disable user/205/com.apple.geod 2>/dev/null || echo "Failed to disable: com.apple.geod"
fi

echo "Operation completed. Please restart your Mac for changes to take full effect."
