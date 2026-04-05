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

  defstruct [:id, :email, :name, :plan]

  @doc "Parse decoded JSON map into struct."
  def parse(nil), do: nil

  def parse(json) when is_map(json) do
    %__MODULE__{
      id: json["id"],
      email: json["email"],
      name: json["name"],
      plan: json["plan"]
    }
  end
end
