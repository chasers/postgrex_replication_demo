import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :replication_demo, ReplicationDemo.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "replication_demo_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :replication_demo, ReplicationDemoWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "qd32wJ0VeV02ZF0Nzs2JlOk7SfIRtz0Vl+4gyi82m6z2e0yawzBpw9+GiljA6SB3",
  server: false

# In test we don't send emails.
config :replication_demo, ReplicationDemo.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
