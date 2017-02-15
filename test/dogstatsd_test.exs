defmodule DogstatsdTest do
  use ExUnit.Case
  use EQC.ExUnit
  # doctest Dogstatsd
  alias Dogstatsd, as: D

  def string, do: utf8()

  @tag numtests: 1000
  property "set metric|value" do
    #   one_of(generate_metric(64)),
    #   one_of(generate_value(128))
    forall [metric, value] <- [string(), int()] do
      ensure D.set(metric, value) == "#{metric}:#{value}|s"
      ensure D.counter(metric, value) == "#{metric}:#{value}|c"
      ensure D.gauge(metric, value) == "#{metric}:#{value}|g"
      ensure D.histogram(metric, value) == "#{metric}:#{value}|h"
    end
  end

  @tag numtests: 1000
  property "increment metric|amount" do
    forall [metric, amount] <- [string(), nat()] do
      implies amount > 0 do
        ensure D.increment(metric, amount) == "#{metric}:#{amount}|c"
        ensure D.decrement(metric, amount) == "#{metric}:-#{amount}|c"
      end
    end
  end

  @tag numtests: 1000
  property "set metric|value with tags" do
    forall [metric, value, tags] <- [string(), int(), list(string())] do
      ensure D.set(metric, value, tags)
        ==  D.set(metric, value) |> with_tags(tags)
      ensure D.counter(metric, value, tags)
        == D.counter(metric, value) |> with_tags(tags)
      ensure D.gauge(metric, value, tags)
        == D.gauge(metric, value) |> with_tags(tags)
      ensure D.histogram(metric, value, tags)
        == D.histogram(metric, value) |> with_tags(tags)
    end
  end

  @tag numtests: 1000
  @doc """
  batch should do this
   [{"keith",123}, {"tanya", 234}] == "keith:123|s\ntanya:234|h"
  """
  property "batch metric|value" do
    forall examples <- list({utf8(), int(), elements(["s", "c", "g", "h"])}) do

      expected = Enum.reduce(examples, "", fn
        (metric, acc) ->
          join(D.metric(metric), acc, "\n")
      end)

      ensure D.batch(examples) == expected
    end
  end

  defp join(a, b, c), do: D.join(a, b, c)

  defp with_tags(something, tags), do: join(something, D.tags(tags), "|")

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
