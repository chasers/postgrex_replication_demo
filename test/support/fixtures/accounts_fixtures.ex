defmodule ReplicationDemo.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ReplicationDemo.Accounts` context.
  """

  @doc """
  Generate a notification.
  """
  def notification_fixture(attrs \\ %{}) do
    {:ok, notification} =
      attrs
      |> Enum.into(%{
        message: "some message"
      })
      |> ReplicationDemo.Accounts.create_notification()

    notification
  end
end
