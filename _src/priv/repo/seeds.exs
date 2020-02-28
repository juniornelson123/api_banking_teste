# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ApiBanking.Repo.insert!(%ApiBanking.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

ApiBanking.Financial.create_user(%{username: "user1", name: "user1", password: "user1@banking"})
ApiBanking.Financial.create_user(%{username: "user2", name: "user2", password: "user2@banking"})
ApiBanking.Financial.create_user(%{username: "admin", name: "admin", password: "admin@banking", admin: true})