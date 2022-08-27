defmodule ReplicationDemo.Accounts.Notification do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notifications" do
    field :message, :string

    timestamps()
  end

  @doc false
  def changeset(notification, attrs) do
    notification
    |> cast(attrs, [:message])
    |> validate_required([:message])
  end
end
