defmodule ReplicationDemoWeb.NotificationsChannel do
  alias Phoenix.PubSub
  use Phoenix.Channel

  def join("notifications:lobby", _message, socket) do
    PubSub.subscribe(ReplicationDemo.PubSub, "postgres")

    {:ok, socket}
  end

  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info({:change, %{new_record: record}}, socket) do
    push(socket, "new_msg", %{new_record: record})
    {:noreply, socket}
  end

  def handle_info({:change, %{old_record: record}}, socket) do
    push(socket, "new_msg", %{old_record: record})
    {:noreply, socket}
  end
end
