## Resource Tag Analysis

The function **timer_TagsToLogAnalytics** is designed to upload resource tags to a central Log Analytics workspace.

It exist because you may want to write [KQL queries](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/) that make use of the resource tags. Log Analytics do not have a log that allow you to link resource tags to resource.

### How it works

The data is stored in a Custom Log called **ResourceTags_CL**.

The log include properties **id_s**, **name_s**, **type_s** and a property for each resource tag.

A resource tag property start with **tags_** followed by tag name and end with the data type of the property. For example '_s' is a string and '_g' is a GUID.

Example query:

```kusto
ResourceTags_CL | where tags_CreatedBy_s == 'John Doe' | project id_s, name_s, type_s, tags_CreatedOn_s
```

::: NOTE
This function is disabled by default and must be enabled if needed.
Be aware that if a new version is installed, the function must be enabled again.
:::

When enabled, this function is called every 24 hours at 11:11 (using 24 hour clock). The schedule can be changed in the Timer Trigger of the function Integration settings, but be aware that if a new version is installed, the setting will be reset to the default.
