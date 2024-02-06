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

  @typedoc """
  SPI bus options

  Options:

  * `mode` - Set the clock polarity and phase to use:
    * Mode 0 (CPOL=0, CPHA=0) - Clock idle low/sample leading edge (default)
    * Mode 1 (CPOL=0, CPHA=1) - Clock idle low/sample trailing edge
    * Mode 2 (CPOL=1, CPHA=0) - Clock idle high/sample leading edge
    * Mode 3 (CPOL=1, CPHA=1) - Clock idle high/sample trailing edge
  * `bits_per_word` - Set the bits per word on the bus. Defaults to 8 bit words.
  * `speed_hz` - Set the bus speed. Supported speeds are device-specific. The
    default speed is 1 Mbps (1000000).
  * `delay_us` - Set the delay between transactions (10)
  * `lsb_first` - Set to `true` to send the least significant bit first rather
    than the most significant one. (false)
  """
  @type spi_option() ::
          {:mode, 0..3}
          | {:bits_per_word, 8..16}
          | {:speed_hz, pos_integer()}
          | {:delay_us, non_neg_integer()}
          | {:lsb_first, boolean()}

  @typedoc """
  SPI bus options as returned by `config/1`.

  These mirror the options that can be passed to `open/2`. `:sw_lsb_first`
  is set if `:lsb_first` is true, but Circuits.SPI is doing this in software.
  """
  @type spi_option_map() :: %{
          mode: 0..3,
          bits_per_word: 8..16,
          speed_hz: pos_integer(),
          delay_us: non_neg_integer(),
          lsb_first: boolean(),
          sw_lsb_first: boolean()
        }


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
  @spec neo_pixel_init(binary()) :: {:ok, Bus.t()} | {:error, term()}
  def neo_pixel_init() do
    {module, _default_options} = default_backend()
    module.init()
  end

  @doc """
  Release any resources associated with the given file descriptor
  """
  @spec close(Bus.t()) :: :ok
  def close(spi_bus) do
    Bus.close(spi_bus)
  end

end
