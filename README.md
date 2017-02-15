# Dogstatsd

Yet another Dogstatsd client written in Elixir using metaprogramming, and OTP.

## Requirements

 - Minimal latency in the mainline processing
 - Non-blocking write of UDP message
 - Fault tolerant

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `dogstatsd` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:dogstatsd, "~> 0.1.0"}]
    end
    ```

  2. Ensure `dogstatsd` is started before your application:

    ```elixir
    def application do
      [applications: [:dogstatsd]]
    end
    ```

## StatsD Features

# Set         'metric:value|s'
# Counter     'metric:value|c'
# Gauge:      'metric:value|g'
# Historgram: 'metric:value|h|@1.0'
# Timing:     'metric:value|ms|#123'
# Batch:      'metric:value|g\nmetric:value|g'
# Tags        'metric:value|c|#country:usa,other,somethingelse'


Counter (name, value, tags)
Event > Message (title, text, tags)
Gauge > Metric (name, value, tags)
Histogram > Metric (name, value, tags)
Message
Metric (name, value, type, tags)
Sender
ServiceCheck (name, value, tags)
Set
Tags (`|##{tags.join(",")}`)
Validator


### Format

data Priority success | info | warning | error
data Alert normal | low

`_e{#{length(title)}, #{length(text)}}:#{title}|#{text}`
`|d:#{timestamp}`
`|h:#{host}`
`|k:#{key}`
`|p:#{priority}`
`|s:#{source}`
`|t:#{tags}`
`|m:#{message}`
`|s:#{set}`

`_sc|#{name}|value`

### UDP Server


int MTU 1440
ONE_MINUTE

data Status OK | WARNING | CRITICAL | UNKNOWN
