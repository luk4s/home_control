# Home control center

Application provide all sensors information from our home in one place. 

## Atrea integration

Requires `atrea_control ~> 4.0`. Publish or provide the new 4.x gem to the
deployment bundle before deploying this app; local development uses an installed
gem, with no sibling-path dependency.

`Home.duplex_user_ctrl` persists the gem's `input_temperature_source` string
(`rd5_standard` or `unsupported`). Existing cached configurations without this
metadata refresh on their next control access. No database migration is needed.
Sensor selection stays inside the gem. Unavailable input temperatures remain
`nil`, display as an em dash, and are omitted from InfluxDB fields; zero is valid.
