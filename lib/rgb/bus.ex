# SPDX-FileCopyrightText: 2023 Frank Hunleth
#
# SPDX-License-Identifier: Apache-2.0

defprotocol Circuits.RGB.Bus do
  @moduledoc """
  A bus is the connection to a real or virtual RGB controller
  """

  @doc """
  Free up resources associated with the bus

  Well behaved backends free up their resources with the help of the Erlang garbage collector. However, it is good
  practice for users to call `Circuits.SPI.close/1` (and hence this function) so that
  limited resources are freed before they're needed again.
  """
  @spec deinit(t()) :: :ok | :error
  def deinit(bus)


end
