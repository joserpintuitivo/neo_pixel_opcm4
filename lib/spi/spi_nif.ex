# SPDX-FileCopyrightText: 2018 Frank Hunleth, Mark Sebald
#
# SPDX-License-Identifier: Apache-2.0

defmodule Circuits.SPI.Nif do
  @moduledoc false

  @on_load {:load_nif, 0}
  @compile {:autoload, false}

  def load_nif() do
    :erlang.load_nif(:code.priv_dir(:circuits_spi) ++ ~c"/spi_nif", 0)
  end

  def init(), do: :erlang.nif_error(:nif_not_loaded)
  def deinit(), do: :erlang.nif_error(:nif_not_loaded)
end
