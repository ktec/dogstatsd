defmodule Dogstatsd do
  @moduledoc """
  A Dogstatsd client
  """

  alias Dogstatsd.Metric, as: M
  alias Dogstatsd.Batch, as: B

  @doc """
  Sends an arbitary set value for the given stat to the statsd server.

  ## Examples

      iex> Dogstatsd.set("deployment", DEPLOYMENT_EVENT_CODE)
      "vdevice.deployment:001|s"

  """
  @spec set(metric :: binary, value :: integer) :: String.t

  defdelegate set(metric, value), to: M
  defdelegate set(metric, value, tags), to: M

  @doc """
  Sends an arbitrary count for the given stat to the statsd server.

  ## Examples

      iex> Dogstatsd.counter("user.count", 100)
      "user.count:100|c"

  """
  @spec counter(metric :: binary, value :: integer) :: String.t

  defdelegate counter(metric, value), to: M
  defdelegate counter(metric, value, tags), to: M

  @doc """
  Sends an arbitary gauge value for the given stat to the statsd server.

  This is useful for recording things like available disk space, memory usage,
  and the like, which have different semantics than counters.

  ## Examples

      iex> Dogstatsd.gauge("user.count", 100)
      "user.count:100|c"

  """
  @spec gauge(metric :: binary, value :: integer) :: String.t

  defdelegate gauge(metric, value), to: M
  defdelegate gauge(metric, value, tags), to: M

  @doc """
  Sends a value to be tracked as a histogram to the statsd server.

  ## Examples

      iex> Dogstatsd.histogram("user.count", 100)
      "user.count:100|c"

  """
  @spec histogram(metric :: binary, value :: integer) :: String.t

  defdelegate histogram(metric, value), to: M
  defdelegate histogram(metric, value, tags), to: M

  @doc """
  Sends an increment count for the given stat to the statsd server.

  ## Examples

      iex> Dogstatsd.increment("user.count")
      "user.count:1|c"
      iex> Dogstatsd.increment("user.count", 10)
      "user.count:10|c"

  """
  @spec increment(metric :: binary, value :: integer) :: String.t

  defdelegate increment(metric, value), to: M

  @doc """
  Sends an decrement count for the given stat to the statsd server.

  ## Examples

      iex> Dogstatsd.decrement("user.count")
      "user.count:1|c"
      iex> Dogstatsd.decrement("user.count", 10)
      "user.count:10|c"

  """
  @spec decrement(metric :: binary, value :: integer) :: String.t

  defdelegate decrement(metric, value), to: M

  @doc """
  Sends an decrement count for the given stat to the statsd server.

  ## Examples

      iex> Dogstatsd.batch({"keith", 123, "s"}, {"tanya", 234, "h"})
      "keith:123|s\ntanya:234|h"

  """
  @spec batch(Enum.t) :: String.t

  defdelegate batch(examples), to: B
  defdelegate metric(metric), to: M
  defdelegate join(a, b, c), to: M
  defdelegate tags(tags), to: M
end
