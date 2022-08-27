defmodule ReplicationDemo.AccountsTest do
  use ReplicationDemo.DataCase

  alias ReplicationDemo.Accounts

  describe "notifications" do
    alias ReplicationDemo.Accounts.Notification

    import ReplicationDemo.AccountsFixtures

    @invalid_attrs %{message: nil}

    test "list_notifications/0 returns all notifications" do
      notification = notification_fixture()
      assert Accounts.list_notifications() == [notification]
    end

    test "get_notification!/1 returns the notification with given id" do
      notification = notification_fixture()
      assert Accounts.get_notification!(notification.id) == notification
    end

    test "create_notification/1 with valid data creates a notification" do
      valid_attrs = %{message: "some message"}

      assert {:ok, %Notification{} = notification} = Accounts.create_notification(valid_attrs)
      assert notification.message == "some message"
    end

    test "create_notification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_notification(@invalid_attrs)
    end

    test "update_notification/2 with valid data updates the notification" do
      notification = notification_fixture()
      update_attrs = %{message: "some updated message"}

      assert {:ok, %Notification{} = notification} = Accounts.update_notification(notification, update_attrs)
      assert notification.message == "some updated message"
    end

    test "update_notification/2 with invalid data returns error changeset" do
      notification = notification_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_notification(notification, @invalid_attrs)
      assert notification == Accounts.get_notification!(notification.id)
    end

    test "delete_notification/1 deletes the notification" do
      notification = notification_fixture()
      assert {:ok, %Notification{}} = Accounts.delete_notification(notification)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_notification!(notification.id) end
    end

    test "change_notification/1 returns a notification changeset" do
      notification = notification_fixture()
      assert %Ecto.Changeset{} = Accounts.change_notification(notification)
    end
  end
end
