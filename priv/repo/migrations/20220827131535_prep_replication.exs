defmodule ReplicationDemo.Repo.Migrations.PrepReplication do
  @moduledoc """
    Handles assigning user permissions for replication and creating the publications.

    Make sure to restart Postgres after for these changes to take effect.

    For Google Cloud SQL set cloudsql.logical_decoding to `on` or `off` respectively.
    https://cloud.google.com/sql/docs/postgres/replication/configure-logical-replication

    TODO: Figure out how to do `execute("alter table "rules" replica identity full")` automatically for
    each table here and for ones created in the future.

    Also see more info: https://hexdocs.pm/postgrex/Postgrex.ReplicationConnection.html
  """

  use Ecto.Migration
  @disable_ddl_transaction true
  @disable_migration_lock true
  @username Application.get_env(:replication_demo, ReplicationDemo.Repo)[:username]
  @env Application.get_env(:replication_demo, :env)
  @publication Application.get_env(:replication_demo, ReplicationDemo.Repo)[:publication]

  def up do
    if @env in [:dev, :test, :prod] do
      # depends on which platform you're hosting Postgres on
      # Google Cloud SQL you must set this config in their admin
      # Postgres must be restarted for this change to take effect
      execute("ALTER SYSTEM SET wal_level = 'logical';")
    end

    # Defaults are 10 but this will limit your cluster size so set accordingly
    execute("ALTER SYSTEM SET max_wal_senders='10';")
    execute("ALTER SYSTEM SET max_replication_slots='10';")

    # Users need replication permissions
    execute("ALTER ROLE #{@username} WITH REPLICATION;")

    # Or you can do this for specific tables
    execute("CREATE PUBLICATION #{@publication} FOR ALL TABLES;")

    # Additionally, after all this you may want to set replica identity to `full`
    # but you need to do that on all your tables and on all new tables after they're created
    #
    # execute("alter table my_table replica identity full")
  end

  def down do
    execute("DROP PUBLICATION #{@publication};")

    execute("ALTER USER #{@username} WITH NOREPLICATION;")

    if @env in [:dev, :test, :prod] do
      execute("ALTER SYSTEM RESET wal_level;")
    end

    execute("ALTER SYSTEM SET max_wal_senders='10';")
    execute("ALTER SYSTEM SET max_replication_slots='10';")
  end
end
