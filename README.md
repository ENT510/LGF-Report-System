## LGF REPORT SYSTEM

Simple report System using Ox Library and LGF Utility for Framework Function

### Configuration

- **Debug Mode**: 
  - Enable or disable debug messages (`Config.DebugEnabled`).

- **Command Panel Report**: 
  - Command to open the report menu for allowed groups (`Config.CommandPannelReport`).

- **Command Send Report**: 
  - Command to send a report (`Config.CommandSendReport`).

- **Webhook for Reports**: 
  - Discord webhook URL to send report data and screenshots (`Config.WebhookReportScreen`).

- **Report Cooldown**: 
  - Cooldown period between sending reports (`Config.CoolDownSendReport`).

### Allowed Groups for Report Panel

- **Config.allowedGroups**: 
  - Only users in these groups ("admin", "mod") or others can access the report panel. (For QBX, currently only works if the permission of the player admin is `admin = true`)

### Report Types

- **Config.TypeReport**: 
  - Different types of reports users can submit, or you can add more:
    - **Bug** (`label = 'Bug', value = 'bug'`)
    - **Report Player** (`label = 'Report Player', value = 'ReportPlayer'`)
    - **Information** (`label = 'Information', value = 'information'`)

### Dependencies

- **LGF UTILITY**: 
  - Required utility for various framework functions.

- **OX LIB**: 
  - Essential library for extended functionalities. [OX LIB](https://github.com/overextended/ox_lib)

- **SCREENSHOT-BASIC**: 
  - Needed for capturing and sending screenshots with reports. [SCREENSHOT-BASIC](https://github.com/citizenfx/screenshot-basic)

This system integrates seamlessly with QBCore, QBX, LGF, and ESX frameworks, ensuring comprehensive support and functionality across different environments.
