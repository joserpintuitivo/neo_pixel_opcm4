# SPDX-FileCopyrightText: 2023 Frank Hunleth
#
# SPDX-License-Identifier: Apache-2.0

defmodule Circuits.SPI.SPIDev do
  @moduledoc """
  Circuits.SPI backend for the Linux spidev interface

  This backend works on Nerves, embedded Linux, and desktop Linux.
  """
  @behaviour Circuits.SPI.Backend

  alias Circuits.SPI.Backend
  alias Circuits.SPI.Nif

  defstruct [:ref]

  @doc """
  Open an SPI bus
  """
  @impl Backend
  def init() do
    with {:ok, ref} <-
           Nif.init() do
      {:ok, %__MODULE__{ref: ref}}
    end
  end

  @impl Backend
    def write_rgb(%Circuits.SPI.SPIDev{ref: ref}, len, data) do
      Nif.write_rgb(ref, len, data)
    end

  @impl Backend
    def deinit() do
      Nif.deinit()
    end

end
