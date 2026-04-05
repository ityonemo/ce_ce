defmodule CeCe.Payload.Outbound.AuthStatus do
  @moduledoc """
  Authentication status message.

  Reports changes in authentication state.
  """

  alias CeCe.Content.AccountInfo

  use CeCe.AccessFunctions

  @type t :: %__MODULE__{
          status: :authenticated | :unauthenticated | :expired | atom(),
          account: AccountInfo.t() | nil,
          message: String.t() | nil
        }

  defstruct [:status, :account, :message]

  @doc "Parse decoded JSON map into struct."
  def parse(json) when is_map(json) do
    %__MODULE__{
      status: parse_status(json["status"]),
      account: AccountInfo.parse(json["account"]),
      message: json["message"]
    }
  end

  defp parse_status("authenticated"), do: :authenticated
  defp parse_status("unauthenticated"), do: :unauthenticated
  defp parse_status("expired"), do: :expired
  defp parse_status(nil), do: :unauthenticated
  defp parse_status(other), do: String.to_atom(other)
end
