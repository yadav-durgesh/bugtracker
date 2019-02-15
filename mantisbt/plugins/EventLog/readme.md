EventLog is a logging plugin for Mantis Bug Tracker.  This allows MantisBT components to log data that is then viewed via the EventLog plugin.

# Installation Instructions

- Place the EventLog folder under the MantisBT plugin folder.

- Go to Manage - Manage Plugins and install the plugin.

- Setup logging level in config_inc.php (see config_defaults_inc.php for documentation).  For example:

```php
$g_log_level = LOG_EMAIL | LOG_EMAIL_RECIPIENT
```

- Do some MantisBT activity (e.g. add notes, report bugs, etc).

- Go to the event log view by clicking: Manage - Event log

# Demo

You can see a demo of it on [MantisHub](http://www.mantishub.com) where it is used to help administrators
understand email notifications, answering questions like why did user X receive or didn't receive an email
notification for issue Y.

# Screenshot

![EventLog Screentshot](wiki/eventlog_screenshot.png "EventLog Screentshot")

# Compatibility

- Supports MantisBT v2.x -- use master branch
- Supports MantisBT v1.3.x -- use master-1.3.x branch
- Supports MantisBT v1.2.x -- use master-1.2.x branch

