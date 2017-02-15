defmodule Dogstatsd.Batch do
  import Dogstatsd.Metric

  def batch([]), do: ""
  def batch([h]), do: metric(h)
  # def batch([h|t]), do: join(batch(t), metric(h), "\n")
  def batch(examples) do
    Enum.reduce(examples, "", fn
      (metric, acc) -> join(metric(metric), acc, "\n")
    end)
  end
end
