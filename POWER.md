# ThinkPad Power Management Guide

## Battery Status Commands
```bash
# Detailed battery information
upower -i /org/freedesktop/UPower/devices/battery_BAT0

# TLP battery status and thresholds
sudo tlp-stat -b

# ACPI information (temperature, cooling)
acpi -V
```

## Battery Charge Control
```bash
# Set full charge mode (useful before travel)
sudo tlp setcharge 5 100 BAT0

# Return to battery-preserving thresholds
sudo tlp setcharge 60 80 BAT0
```

These commands are temporary. After reboot, your NixOS configuration thresholds (60-80) will be restored.

## TLP Configuration Explained

Our configuration (`services.tlp.settings`) manages several power aspects:

1. **Battery Thresholds** (60-80%): Extends battery lifespan by preventing full charges and deep discharges
2. **CPU Management**: Performance on AC, power saving on battery
3. **Disk & PCIe**: Balanced power/performance settings
4. **WiFi & USB**: Power saving features with longer timeouts on AC
5. **USB Device Exceptions**: Prevents power management for specific USB devices (keyboard, mouse) to ensure responsiveness

## Power Alerts (UPower)
- Low Battery: 15%
- Critical: 10%
- Emergency Action (Hibernate): 5%
