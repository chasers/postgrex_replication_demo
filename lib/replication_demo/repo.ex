defmodule ReplicationDemo.Repo do
  use Ecto.Repo,
    otp_app: :replication_demo,
    adapter: Ecto.Adapters.Postgres
end
