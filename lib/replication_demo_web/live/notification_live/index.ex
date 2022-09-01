defmodule ReplicationDemoWeb.NotificationLive.Index do
  use ReplicationDemoWeb, :live_view

  alias ReplicationDemo.Accounts
  alias ReplicationDemo.Accounts.Notification
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: PubSub.subscribe(ReplicationDemo.PubSub, "postgres")

    socket =
      socket
      |> assign(:notifications, list_notifications())
      |> assign(:latest_change, nil)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Notification")
    |> assign(:notification, Accounts.get_notification!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Notification")
    |> assign(:notification, %Notification{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Notifications")
    |> assign(:notification, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    notification = Accounts.get_notification!(id)
    {:ok, _} = Accounts.delete_notification(notification)

    {:noreply, assign(socket, :notifications, list_notifications())}
  end

  @impl true
  def handle_info({:change, %{new_record: record}}, socket) do
    {:noreply, assign(socket, :latest_change, record.id)}
  end

  def handle_info({:change, %{old_record: record}}, socket) do
    {:noreply, assign(socket, :latest_change, record.id)}
  end

  defp list_notifications do
    Accounts.list_notifications()
  end
end
