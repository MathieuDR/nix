# NixOS Configuration TODOs

This document outlines various improvements and additions that could be made to the NixOS configuration.

## 1. Automatic Garbage Collection
NixOS stores multiple generations of system configurations and packages, which can consume significant disk space over time. Automated garbage collection helps maintain system health by removing unused packages and old generations while preserving recent history for rollbacks.

**Ideas to include:**
- [x] Use [nix-profile-gc](https://git.scottworley.com/nix-profile-gc)

## 2. Backups
A robust backup strategy is crucial for protecting important data. Using restic with Backblaze B2 provides encrypted, incremental backups with version history and deduplication capabilities.

**Ideas to include:**
- [ ] Critical directory identification
- [ ] Backup scheduling
- [ ] Retention policies
- [ ] Encryption configuration
- [ ] Test restore procedures
- [ ] Backup monitoring

## 3. Systemd Boot Enhancements
Systemd-boot configuration can be optimized for better boot management and system recovery options. This includes managing boot entries, timeouts, and security settings.

**Ideas to include:**
- [ ] Generation limits
- [ ] Boot menu timeout
- [ ] Console resolution settings
- [ ] Boot entry editor controls
- [ ] Boot menu customization

## 4. System Upgrade Notifications
Stay informed about available system updates without committing to automatic upgrades. This helps maintain system security while retaining control over when updates are applied.

**Ideas to include:**
- [ ] Update check scheduling
- [ ] Change summary generation
- [ ] Notification system integration
- [ ] Update review process
- [ ] Security update highlighting

## 5. Disk Encryption
Protect sensitive data from unauthorized access in case of physical access to the machine. Particularly important for mobile devices like laptops.

**Ideas to include:**
- [ ] Partition encryption strategy
- [ ] Key management
- [ ] Recovery procedures
- [ ] Performance considerations
- [ ] Boot process integration

## 6. Impermanence
Maintain a clean, reproducible system state by explicitly declaring which files and directories should persist across reboots. This helps prevent configuration drift and ensures system reliability.

**Ideas to include:**
- [ ] Persistent directory structure
- [ ] State management strategy
- [ ] Service data handling
- [ ] User data persistence
- [ ] Backup integration

## 7. Firewall Configuration
Basic network security for personal machines, particularly important when connecting to public networks or running local services.

**Ideas to include:**
- [ ] Required port identification
- [ ] Service-specific rules
- [ ] Network zone configuration
- [ ] Logging settings
- [ ] Rule organization

## 8. User Permissions
Ensure proper access control and security through careful user permission management and sudo configuration.

**Ideas to include:**
- [ ] Sudo rule review
- [ ] Group membership audit
- [ ] Polkit rule verification
- [ ] Service access controls
- [ ] Default permission policies
