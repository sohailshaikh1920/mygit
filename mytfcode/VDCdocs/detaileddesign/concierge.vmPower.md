## Virtual Machine Power Management

The function **timer_VMPowerManagement** is designed to handle automatic shutdown and startup of Virtual Machines.

### How it works

The Azure Resource Graph is used to find all Virtual Machines tagged with the **Power** tag.

The information in the tag value is used to determine if the machine should be on or off. If the machine state is not according to tag requirement, it will be stopped or started.

The function will not wait to check if the machine was successfully stopped or started. This can be achieved using another mechanism, like Azure Alerts.

The **Power** tag value must be in the format of a JSON string and can include the following properties:

| Name         | Type   | Required | Description                                                                  |
| ------------ | ------ | -------- | ---------------------------------------------------------------------------- |
| TimeZone     | string | No       | The time zone for StartTime and StopTime. If unspecified, UTC is used.       |
| CronOn       | string | No       | If current date/time match cron expression(s), the VM should be running.     |
| CronOff      | string | No       | If current date/time match cron expression(s), the VM should not be running. |
| AutoShutDown | bool   | No       | Perform automatic shutdown of the VM.                                        |
| StartTime    | string | No       | The time, in 24 hour format, when the VM should be running.                  |
| StartDays    | string | No       | A comma separated list of week days when StartTime should be applied.        |
| StopTime     | string | No       | The time, in 24 hour format, when the VM should be off.                      |
| StopDays     | string | No       | A comma separated list of week days when StopTime should be applied.         |

> **Guidance**:
>
> * If **CronOn** is specified all other properties, except TimeZone, are ignored.
> * If **CronOff** is specified (and **CronOn** is not specified) all other properties, except TimeZone, are ignored.
> * If **AutoShutDown** is false or not specified, **StopTime** is ignored and shutdown will not occur.
> * Either **StartTime** or **StopTime** or both should always be specified. There is no reason to add the Power tag if not.

This function is called every 10 minutes. The schedule can be changed in the Timer Trigger of the function Integration settings, but be aware that if a new version is installed, the setting will be reset to the default 10 minutes.

### TimeZone

A list of valid TimeZone values can be retrieved using PowerShell:

```powershell
Get-TimeZone -ListAvailable | Select-Object -ExpandProperty Id;
```

### CronOn and CronOff

The value of CronOn and CronOff should be one or more cron expressions, separated by pipe |. These are optional properties and an alternative to the StartTime, StartDays, StopTime, StopDays and AutoShutDown properties.

Use CronOn to specify when a VM should be running. Use CronOff to specify when a VM should not be running. Do not use both CronOn and CronOff at the same time.

Cron expression format: minute hour day-of-month month day-of-week

If both day-of-month and day-of-week is specified, day-of-month will be interpreted as the Nth such day in the month. To request the last Monday, etc. in a month, ask for the "5th" one. This will always match the last Monday, etc., even if there are only four Mondays in the month.

### StartDays and StopDays

The value to use in StartDays and StopDays properties follow the .NET of [System.DateTime.DayOfWeek](https://docs.microsoft.com/en-us/dotnet/api/system.datetime.dayofweek).

The value ranges from 0 (Sunday) to 6 (Saturday). If StartDays or StopDays is not specified, action will be applied on all days. See examples below.

### Power tag value examples

Ensure VM is running at every minute past every hour from 7 through 16 and at every minute past hour 0 and 23 on last Saturday of every month, and use W. Europe Standard Time:

```json
{ "CronOn": "* 7-16 * * *|* 0,23 5 * 6", "TimeZone": "W. Europe Standard Time" }
```

Start a VM at 07:00 all days, use default UTC time:

```json
{ "StartTime": "0700" }
```

Start a VM at 09:00 on Monday to Friday and stop it at 16:00 any day, and use W. Europe Standard Time:

```json
{ "AutoShutDown": true, "StartTime": "0900", "StartDays": "1,2,3,4,5", "StopTime": "1600", "TimeZone": "W. Europe Standard Time" }
```
