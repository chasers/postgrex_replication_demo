defmodule ReplicationDemoWeb.NotificationLive.FormComponent do
  use ReplicationDemoWeb, :live_component

  alias ReplicationDemo.Accounts

  @impl true
  def update(%{notification: notification} = assigns, socket) do
    changeset = Accounts.change_notification(notification)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"notification" => notification_params}, socket) do
    changeset =
      socket.assigns.notification
      |> Accounts.change_notification(notification_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"notification" => notification_params}, socket) do
    save_notification(socket, socket.assigns.action, notification_params)
  end

  defp save_notification(socket, :edit, notification_params) do
    case Accounts.update_notification(socket.assigns.notification, notification_params) do
      {:ok, _notification} ->
        {:noreply,
         socket
         |> put_flash(:info, "Notification updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_notification(socket, :new, notification_params) do
    case Accounts.create_notification(notification_params) do
      {:ok, _notification} ->
        {:noreply,
         socket
         |> put_flash(:info, "Notification created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
