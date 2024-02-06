# SPDX-FileCopyrightText: 2023 Frank Hunleth
#
# SPDX-License-Identifier: Apache-2.0

defmodule Circuits.RGB.Backend do
  @moduledoc """
  Backends provide the connection to the real or virtual SPI controller
  """
  alias Circuits.RGB.Bus

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
  @callback init() ::
              {:ok, Bus.t()} | {:error, term()}

  @callback write_rgb(Bus.t(), integer(), integer()) ::
              :ok | :error

  @callback deinit() ::
              :ok | :error

end
