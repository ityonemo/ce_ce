defmodule CeCe.Content.AccountInfo do
  @moduledoc """
  Account information.
  """

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          id: String.t() | nil,
          email: String.t() | nil,
          name: String.t() | nil,
          plan: String.t() | nil
        }

  @derive JSON.Encoder
  defstruct [:id, :email, :name, :plan]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_map(json) do
    # All fields are optional
    %__MODULE__{
      id: Map.get(json, "id"),
      email: Map.get(json, "email"),
      name: Map.get(json, "name"),
      plan: Map.get(json, "plan")
    }
  end
end
