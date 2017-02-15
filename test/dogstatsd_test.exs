defmodule DogstatsdTest do
  use ExUnit.Case
  use EQC.ExUnit
  # doctest Dogstatsd
  require Dogstatsd

  @tag numtests: 1000
  property "set metric|value" do
    #   one_of(generate_metric(64)),
    #   one_of(generate_value(128))
    forall [metric, value] <- [utf8, int] do
      ensure Dogstatsd.set(metric, value) == "#{metric}:#{value}|s"
      ensure Dogstatsd.counter(metric, value) == "#{metric}:#{value}|c"
      ensure Dogstatsd.gauge(metric, value) == "#{metric}:#{value}|g"
      ensure Dogstatsd.histogram(metric, value) == "#{metric}:#{value}|h"
      ensure Dogstatsd.increment(metric) == "#{metric}:1|c"
      ensure Dogstatsd.decrement(metric) == "#{metric}:-1|c"
    end
  end

  @tag numtests: 1000
  property "set metric|value with tags" do
    forall [metric, value, tags] <- [utf8, int, list(utf8)] do
      ensure Dogstatsd.set(metric, value, tags)
        ==  Dogstatsd.set(metric, value) |> with_tags(tags)
      ensure Dogstatsd.counter(metric, value, tags)
        == Dogstatsd.counter(metric, value) |> with_tags(tags)
      ensure Dogstatsd.gauge(metric, value, tags)
        == Dogstatsd.gauge(metric, value) |> with_tags(tags)
      ensure Dogstatsd.histogram(metric, value, tags)
        == Dogstatsd.histogram(metric, value) |> with_tags(tags)
    end
  end

  @tag numtests: 1000
  @doc """
  batch should do this
   [{"keith",123}, {"tanya", 234}] == "keith:123|s\ntanya:234|h"
  """
  property "batch metric|value" do
    forall examples <- list({utf8, int, elements(["s", "c", "g", "h"])}) do

      expected = Enum.reduce(examples, "", fn
        (metric, acc) ->
          join(Dogstatsd.metric(metric), acc, "\n")
      end)

      ensure Dogstatsd.batch(examples) == expected
    end
  end

  defp join(a, b, c), do: Dogstatsd.join(a, b, c)

  defp with_tags(something, tags), do: join(something, Dogstatsd.tags(tags), "|")

  # defp generate_metric(length) do
  #   :crypto.strong_rand_bytes(length)
  #   |> Base.url_encode64
  #   |> binary_part(0, length)
  # end
  #
  # defp generate_value(length) do
  #   Enum.random(0..length)
  # end
end
