# SPDX-FileCopyrightText: 2023 Frank Hunleth
#
# SPDX-License-Identifier: Apache-2.0

defmodule Circuits.RGB.RGBDev do
  @moduledoc """
  Circuits.RGB backend for the Linux spidev interface

  This backend works on Nerves, embedded Linux, and desktop Linux.
  """
  @behaviour Circuits.RGB.Backend

  alias Circuits.RGB.Backend
  alias Circuits.RGB.Nif

  defstruct [:ref]

  @doc """
  Open an RBG bus
  """
  @impl Backend
  def init() do
    with {:ok, ref} <-
           Nif.init() do
      {:ok, %__MODULE__{ref: ref}}
    end
  end

  @impl Backend
    def write_rgb(%Circuits.RGB.RGBDev{ref: ref}, len, data) do
      Nif.write_rgb(ref, len, data)
    end

  @impl Backend
    def deinit() do
      Nif.deinit()
    end

end
