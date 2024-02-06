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
  alias Circuits.SPI.Bus
  alias Circuits.SPI.Nif

  defstruct [:ref]

  @doc """
  Return the SPI bus names on this system

  No supported options
  """
  case System.get_env("CIRCUITS_SPI_SPIDEV") do
    "test" ->
      @impl Backend
      def bus_names(_options), do: ["spidev0.0"]

    "normal" ->
      @impl Backend
      def bus_names(_options) do
        Path.wildcard("/dev/spidev*")
        |> Enum.map(fn p -> String.replace_prefix(p, "/dev/", "") end)
      end

    _ ->
      @impl Backend
      def bus_names(_options) do
        []
      end
  end

  @doc """
  Open an SPI bus
  """
  @impl Backend
  def init() do
    with {:ok, ref} <-
           Nif.neo_pixel_init() do
      {:ok, %__MODULE__{ref: ref}}
    end
  end


  defimpl Bus do

    @impl Bus
    def deinit() do
      Nif.neo_pixel_deinit()
    end

  end
end
