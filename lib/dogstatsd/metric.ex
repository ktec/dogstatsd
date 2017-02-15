defmodule Dogstatsd.Metric do
  def set(metric, value), do: "#{metric}:#{value}|s"
  def set(metric, value, ts),
    do: join(set(metric, value), tags(ts), "|")

  def counter(metric, value), do: "#{metric}:#{value}|c"
  def counter(metric, value, ts),
    do: join(counter(metric, value), tags(ts), "|")

  def gauge(metric, value), do: "#{metric}:#{value}|g"
  def gauge(metric, value, ts),
    do: join(gauge(metric, value), tags(ts), "|")

  def histogram(metric, value), do: "#{metric}:#{value}|h"
  def histogram(metric, value, ts),
    do: join(histogram(metric, value), tags(ts), "|")

  def increment(a, b \\ 1)
  def increment(_, 0), do: ""
  def increment(metric, amount)
    when amount > 0, do: "#{metric}:#{amount}|c"

  def decrement(a, b \\ 1)
  def decrement(_, 0), do: ""
  def decrement(metric, amount)
    when amount > 0, do: "#{metric}:-#{amount}|c"

  def metric({<<>>, _, _}), do: ""
  def metric({metric, value, "s"}), do: set(metric, value)
  def metric({metric, value, "c"}), do: counter(metric, value)
  def metric({metric, value, "g"}), do: gauge(metric, value)
  def metric({metric, value, "h"}), do: histogram(metric, value)

  def join("", b, _), do: b
  def join(a, "", _), do: a
  def join(a, b, c), do: a <> c <> b

  def tags([]), do: ""
  def tags([""]), do: ""
  # def tags([<<>>]), do: ""
  def tags([<<0>>]), do: ""
  def tags(ts), do: "#" <> Enum.join(ts, ",")
end
