# SPDX-FileCopyrightText: 2023 Frank Hunleth
#
# SPDX-License-Identifier: Apache-2.0

defmodule Circuits.SPI.NilBackend do
  @moduledoc """
  Circuits.SPI backend when nothing else is available
  """
  @behaviour Circuits.SPI.Backend

  alias Circuits.SPI.Backend

  @doc """
  Open an I2C bus

  No supported options.
  """
  @impl Backend
  def init() do
    {:error, :unimplemented}
  end

  @impl Backend
  def write(_bus, _len, _data) do
    :error
  end

  @impl Backend
  def deinit() do
    :error
  end

end
