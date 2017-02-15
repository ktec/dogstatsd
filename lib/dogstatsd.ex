defmodule Dogstatsd do
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

  def increment(metric), do: "#{metric}:1|c"
  def decrement(metric), do: "#{metric}:-1|c"

  def batch([]), do: ""
  def batch([h]), do: metric(h)
  # def batch([h|t]), do: join(batch(t), metric(h), "\n")
  def batch(examples) do
    Enum.reduce(examples, "", fn
      (metric, acc) -> join(metric(metric), acc, "\n")
    end)
  end

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
  def tags([<<>>]), do: ""
  def tags([<<0>>]), do: ""
  def tags(ts), do: "#" <> Enum.join(ts, ",")
end
