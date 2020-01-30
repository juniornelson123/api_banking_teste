defmodule ApiBanking.FinancialTest do
  use ApiBanking.DataCase

  alias ApiBanking.Financial

  describe "users" do
    alias ApiBanking.Financial.User

    @valid_attrs %{email: "some email", name: "some name", password: "some password"}
    @update_attrs %{email: "some updated email", name: "some updated name", password: "some updated password"}
    @invalid_attrs %{email: nil, name: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Financial.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Financial.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Financial.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Financial.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.name == "some name"
      assert user.password == "some password"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financial.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Financial.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert user.password == "some updated password"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Financial.update_user(user, @invalid_attrs)
      assert user == Financial.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Financial.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Financial.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Financial.change_user(user)
    end
  end

  describe "accounts" do
    alias ApiBanking.Financial.Account

    @valid_attrs %{amount: 120.5, number: "some number"}
    @update_attrs %{amount: 456.7, number: "some updated number"}
    @invalid_attrs %{amount: nil, number: nil}

    def account_fixture(attrs \\ %{}) do
      {:ok, account} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Financial.create_account()

      account
    end

    test "list_accounts/0 returns all accounts" do
      account = account_fixture()
      assert Financial.list_accounts() == [account]
    end

    test "get_account!/1 returns the account with given id" do
      account = account_fixture()
      assert Financial.get_account!(account.id) == account
    end

    test "create_account/1 with valid data creates a account" do
      assert {:ok, %Account{} = account} = Financial.create_account(@valid_attrs)
      assert account.amount == 120.5
      assert account.number == "some number"
    end

    test "create_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financial.create_account(@invalid_attrs)
    end

    test "update_account/2 with valid data updates the account" do
      account = account_fixture()
      assert {:ok, %Account{} = account} = Financial.update_account(account, @update_attrs)
      assert account.amount == 456.7
      assert account.number == "some updated number"
    end

    test "update_account/2 with invalid data returns error changeset" do
      account = account_fixture()
      assert {:error, %Ecto.Changeset{}} = Financial.update_account(account, @invalid_attrs)
      assert account == Financial.get_account!(account.id)
    end

    test "delete_account/1 deletes the account" do
      account = account_fixture()
      assert {:ok, %Account{}} = Financial.delete_account(account)
      assert_raise Ecto.NoResultsError, fn -> Financial.get_account!(account.id) end
    end

    test "change_account/1 returns a account changeset" do
      account = account_fixture()
      assert %Ecto.Changeset{} = Financial.change_account(account)
    end
  end

  describe "transactions" do
    alias ApiBanking.Financial.Transaction

    @valid_attrs %{amount: 120.5, kind: "some kind"}
    @update_attrs %{amount: 456.7, kind: "some updated kind"}
    @invalid_attrs %{amount: nil, kind: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Financial.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Financial.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Financial.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Financial.create_transaction(@valid_attrs)
      assert transaction.amount == 120.5
      assert transaction.kind == "some kind"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financial.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{} = transaction} = Financial.update_transaction(transaction, @update_attrs)
      assert transaction.amount == 456.7
      assert transaction.kind == "some updated kind"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Financial.update_transaction(transaction, @invalid_attrs)
      assert transaction == Financial.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Financial.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Financial.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Financial.change_transaction(transaction)
    end
  end

  describe "transactions" do
    alias ApiBanking.Financial.Transaction

    @valid_attrs %{amount: 120.5}
    @update_attrs %{amount: 456.7}
    @invalid_attrs %{amount: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Financial.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Financial.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Financial.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Financial.create_transaction(@valid_attrs)
      assert transaction.amount == 120.5
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financial.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{} = transaction} = Financial.update_transaction(transaction, @update_attrs)
      assert transaction.amount == 456.7
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Financial.update_transaction(transaction, @invalid_attrs)
      assert transaction == Financial.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Financial.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Financial.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Financial.change_transaction(transaction)
    end
  end

  describe "transfers" do
    alias ApiBanking.Financial.Transfer

    @valid_attrs %{amount: 120.5}
    @update_attrs %{amount: 456.7}
    @invalid_attrs %{amount: nil}

    def transfer_fixture(attrs \\ %{}) do
      {:ok, transfer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Financial.create_transfer()

      transfer
    end

    test "list_transfers/0 returns all transfers" do
      transfer = transfer_fixture()
      assert Financial.list_transfers() == [transfer]
    end

    test "get_transfer!/1 returns the transfer with given id" do
      transfer = transfer_fixture()
      assert Financial.get_transfer!(transfer.id) == transfer
    end

    test "create_transfer/1 with valid data creates a transfer" do
      assert {:ok, %Transfer{} = transfer} = Financial.create_transfer(@valid_attrs)
      assert transfer.amount == 120.5
    end

    test "create_transfer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Financial.create_transfer(@invalid_attrs)
    end

    test "update_transfer/2 with valid data updates the transfer" do
      transfer = transfer_fixture()
      assert {:ok, %Transfer{} = transfer} = Financial.update_transfer(transfer, @update_attrs)
      assert transfer.amount == 456.7
    end

    test "update_transfer/2 with invalid data returns error changeset" do
      transfer = transfer_fixture()
      assert {:error, %Ecto.Changeset{}} = Financial.update_transfer(transfer, @invalid_attrs)
      assert transfer == Financial.get_transfer!(transfer.id)
    end

    test "delete_transfer/1 deletes the transfer" do
      transfer = transfer_fixture()
      assert {:ok, %Transfer{}} = Financial.delete_transfer(transfer)
      assert_raise Ecto.NoResultsError, fn -> Financial.get_transfer!(transfer.id) end
    end

    test "change_transfer/1 returns a transfer changeset" do
      transfer = transfer_fixture()
      assert %Ecto.Changeset{} = Financial.change_transfer(transfer)
    end
  end
end
