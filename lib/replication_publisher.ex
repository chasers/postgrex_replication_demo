defmodule ReplicationDemo.ReplicationPublisher do
  @moduledoc """
  Publishes messages from Replication to PubSub
  """

  use GenServer

  alias PgoutputDecoder.Messages
  alias Phoenix.PubSub

  defstruct [:relations]

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def process_message(message) do
    GenServer.cast(__MODULE__, {:message, message})
  end

  @impl true
  def init(_stack) do
    {:ok, %__MODULE__{}}
  end

  @impl true
  def handle_cast({:message, %Messages.Relation{} = message}, state) do
    relations = [message | state.relations]
    {:noreply, %{state | relations: relations}}
  end

  @impl true
  def handle_cast(
        {:message, %Messages.Delete{relation_id: rel_id, old_tuple_data: nil} = message},
        state
      ) do
    relation = Enum.find(state.relations, &(rel_id == &1.id))

    if relation do
      record =
        for {column, index} <- Enum.with_index(relation.columns),
            do: {String.to_atom(column.name), elem(message.changed_key_tuple_data, index)},
            into: %{}

      change = %{relation: relation, old_record: record}

      PubSub.local_broadcast(ReplicationDemo.PubSub, "postgres", {:change, change})

      {:noreply, state}
    else
      {:noreply, state}
    end
  end

  @impl true
  def handle_cast({:message, %Messages.Delete{relation_id: rel_id} = message}, state) do
    relation = Enum.find(state.relations, &(rel_id == &1.id))

    if relation do
      record =
        for {column, index} <- Enum.with_index(relation.columns),
            do: {String.to_atom(column.name), elem(message.old_tuple_data, index)},
            into: %{}

      change = %{relation: relation, old_record: record}

      PubSub.local_broadcast(ReplicationDemo.PubSub, "postgres", {:change, change})

      {:noreply, state}
    else
      {:noreply, state}
    end
  end

  @impl true
  def handle_cast({:message, %{relation_id: rel_id} = message}, state) do
    relation = Enum.find(state.relations, &(rel_id == &1.id))

    if relation do
      record =
        for {column, index} <- Enum.with_index(relation.columns),
            do: {String.to_atom(column.name), elem(message.tuple_data, index)},
            into: %{}

      change = %{relation: relation, new_record: record}

      PubSub.local_broadcast(ReplicationDemo.PubSub, "postgres", {:change, change})

      {:noreply, state}
    else
      {:noreply, state}
    end
  end

  @impl true
  def handle_cast({:message, _message}, state) do
    :noop
    {:noreply, state}
  end
end
