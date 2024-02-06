# SPDX-FileCopyrightText: 2023 Frank Hunleth
#
# SPDX-License-Identifier: Apache-2.0

defmodule Circuits.RGB.NilBackend do
  @moduledoc """
  Circuits.RGB backend when nothing else is available
  """
  @behaviour Circuits.RGB.Backend

  alias Circuits.RGB.Backend

  @doc """
  Open an I2C bus

  No supported options.
  """
  @impl Backend
  def init() do
    {:error, :unimplemented}
  end

  @impl Backend
  def write_rgb(_bus, _len, _data) do
    :error
  end

  @impl Backend
  def deinit() do
    :error
  end

end
