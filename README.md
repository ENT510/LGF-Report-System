# LGF REPORT SYSTEM

Simple report System using Ox Library

## FRAMEWORK

- LGF
- QBOX
- ESX

<table>
  <tr>
    <td><img src="https://github.com/ENT510/LGF-Report-System/assets/145626625/1707ce35-4d0c-404c-851a-5491095b64d7" alt="Pin Creation" width="300"/></td>
    <td><img src="https://github.com/ENT510/LGF-Report-System/assets/145626625/e864336f-c7b4-471f-b9d4-4b6a963a4c88" alt="Create Fake Card" width="300"/></td>
    <td><img src="https://github.com/ENT510/LGF-Report-System/assets/145626625/e1f52c70-4c16-4fe9-9234-2b940990ffa0" alt="Create Fake Card" width="300"/></td>
  </tr>
</table>

### Configuration


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
  - Only users in these groups ("admin", "mod") or others can access the report panel[qbox work with 'admin' 'ace perms']

### Report Types

- **Config.TypeReport**: 
  - Different types of reports users can submit, or you can add more:
    - **Bug** (`label = 'Bug', value = 'bug'`)
    - **Report Player** (`label = 'Report Player', value = 'ReportPlayer'`)
    - **Information** (`label = 'Information', value = 'information'`)

### Dependencies

- **OX LIB**: 
  - Essential library for extended functionalities. [OX LIB](https://github.com/overextended/ox_lib)

- **SCREENSHOT-BASIC**: 
  - Needed for capturing and sending screenshots with reports. [SCREENSHOT-BASIC](https://github.com/citizenfx/screenshot-basic)

