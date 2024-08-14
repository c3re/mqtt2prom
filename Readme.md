# mqtt2prom

This service is a mqtt-to-prometheus gateway.

it is configured with the following ENV-Variables, the ones suffiexed with a `*` are mandatory, default values are after `|`:

```
MQTT_HOST*
MQTT_PORT|1883
MQTT_USER
MQTT_PASS
MQTT_CLIENT_ID|mqtt2prometheus
MQTT_TOPIC|prometheus
MQTT_QOS|2

```

it will listen on the configured mqtt server at `$MQTT_TOPIC` for metrics in json_format.

The payload needs to be an object containing only the following keys:

- `name` (string): the name of the metric
- `value` (number): the value of the metric
- `labels` (object, optional): an object containing the labels for the metric (key-value pairs of strings)

According to prometheus conventions, the metric name and the label names need to be a lower or upper case letter or a underscore followed by all case leters, numbers or underscores.

These are all valid payloads:

```json
{
  "name": "temperature",
  "value": 30.7,
  "labels": {
    "unit": "°C",
    "location": "Werkstatt"
  }
}
```

```json
{
  "name": "temperature",
  "value": 30.7,
  "labels": {}
}
```

```json
{
  "name": "temperature",
  "value": 30.7
}
```

The service will expose the metrics on the `/metrics` endpoint.
All metrics will be presented for about 5 minutes, and exported with their eventtime as a timestamp.

Metric types are not currently implemented, all metrics are exported without a type.
This might change when prometheus supports it.

The service will report errors in received messages to STDERR and to $MQTT_TOPIC/error.
Possible errors are:

- invalid json
- missing `name` or `value` key
- invalid `name` (prometheus conventions)
- invalid `value` (not a number)
- invalid `labels` (not an object)
- invalid label names (not a sting or not a valid prometheus label name)
- invalid label values (not a string)
- additional information in the payload (not one of `name`, `value`, `labels`)

The error message describes the error type and repeats the payload that caused the error.

There is a comment block on top if the metric that shows some metadata for human consumption.

mem usage and mem usage peak is according to [memory_get_usage()](https://www.php.net/manual/en/function.memory-get-usage.php) and [memory_get_peak_usage()](https://www.php.net/manual/en/function.memory-get-peak-usage.php) respectively.
in both cases it gives 2 values, the first is the acutally used value, the second is tha allocated.

A new export is written either

- once oper second if new events are incoming.
- every 15 seconds if no new events are incoming, to update stats and remove stale entries.

There is a 60 second period on startup where metrics are received but not exported, in case the service crashes and there are previous exported metrics that are not polled by prometheus yet.
