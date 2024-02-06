# SPDX-FileCopyrightText: 2018 Frank Hunleth, Mark Sebald
#
# SPDX-License-Identifier: Apache-2.0

defmodule Circuits.SPI do
  @moduledoc """
  This module enables Elixir programs to interact with hardware that's connected
  via a SPI bus.
  """

  alias Circuits.SPI.Bus

  @typedoc """
  Backends specify an implementation of a Circuits.SPI.Backend behaviour

  The second parameter of the Backend 2-tuple is a list of options. These are
  passed to the behaviour function call implementations.
  """
  @type backend() :: {module(), keyword()}

  @doc """
  Open a SPI bus device

  On success, `open/2` returns a reference that may be passed to
  with `transfer/2`. The device will be closed automatically when
  the reference goes out of scope.

  SPI is not a standardized interface so appropriate options will
  different from device-to-device. The defaults use here work on
  many devices.

  Parameters:
  * `bus_name` is the name of the bus (e.g., "spidev0.0"). See `bus_names/0`
  * `opts` is a keyword list to configure the bus
  """
  @spec init() :: {:ok, Bus.t()} | {:error, term()}
  def init() do
    {module, _default_options} = default_backend()
    module.init()
  end

  @doc """
  Release any resources associated with the given file descriptor
  """
  @spec deinit() :: :ok | :error
  def deinit() do
    {module, _default_options} = default_backend()
    module.deinit()
  end

  defp default_backend() do
    case Application.get_env(:circuits_spi, :default_backend) do
      nil -> {Circuits.SPI.NilBackend, []}
      m when is_atom(m) -> {m, []}
      {m, o} = value when is_atom(m) and is_list(o) -> value
    end
  end

end
