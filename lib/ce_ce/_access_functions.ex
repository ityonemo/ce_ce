defmodule CeCe.AccessFunctions do
  defmacro __using__(_) do
    quote do
      @behaviour Access

      @impl Access
      def fetch(struct, key), do: Map.fetch(struct, key)

      @impl Access
      def get_and_update(_, _, _), do: raise("#{inspect(__MODULE__)} is read-only")

      @impl Access
      def pop(_, _), do: raise("#{inspect(__MODULE__)} is read-only")
    end
  end
end
