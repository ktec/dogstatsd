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

 - Set         'metric:value|s'
 - Counter     'metric:value|c'
 - Gauge:      'metric:value|g'
 - Historgram: 'metric:value|h|@1.0'
 - Timing:     'metric:value|ms|#123'
 - Batch:      'metric:value|g\nmetric:value|g'
 - Tags        'metric:value|c|#country:usa,other,somethingelse'

Counter { name :: String, value :: String, tags :: Maybe [Tag] }     
Message { title :: String, text :: String, tags :: [Tag] }

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

OptimalPayloadSize defines the optimal payload size for a UDP datagram, 1432 bytes
is optimal for regular networks with an MTU of 1500 so datagrams don't get
fragmented. It's generally recommended not to fragment UDP datagrams as losing
a single fragment will cause the entire datagram to be lost.
This can be increased if your network has a greater MTU or you don't mind UDP
datagrams getting fragmented. The practical limit is MaxUDPPayloadSize


#### Event

 - title [required] max_length 100
 - text [required] max_length 4000
 - date_happened [optional, default=now] (POSIX timestamp)
 - priority [optional, default='normal'] one_of ['normal', 'low']
 - host [optional, default=None]
 - tags [optional, default=None]
 - alert_type [optional, default='info'] one_of ["error", "warning", "info", "success"]
 - aggregation_key [optional, default=None] max length 100
 - source_type_name [optional, default=None] one_of [jenkins, user, chef, puppet, git ... ]

 `_e{#{length(title)}, #{length(text)}}:#{title}|#{text}`
 `_e{title.length,text.length}:title|text|d:date_happened|h:hostname|p:priority|t:alert_type|#tag1,tag2`

 data Status OK | WARNING | CRITICAL | UNKNOWN
 data Priority = Normal | Low

 data Event = Event { title :: String
                    , text :: String
                    , dateHappened :: Maybe Time
                    , priority :: Maybe Priority
                    , host :: Maybe String
                    , tags :: Maybe String
                    }
