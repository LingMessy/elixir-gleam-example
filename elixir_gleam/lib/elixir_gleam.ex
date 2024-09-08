defmodule ElixirGleam do
  @moduledoc """
  Documentation for `ElixirGleam`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ElixirGleam.hello()
      :world

  """
  def hello do
    :world
  end
end

defmodule ElixirGleam.Func do
  def sum_and_square(int_list) do
    :test_gleam.sum_int_list(int_list) |> :math.pow(2)
  end
end

defmodule ElixirGleam.Application do
  use Application

  def start(_type, _args) do
    # 在此处调用 gleam 的方法
    :test_gleam.sum_int_list([1, 2222, 1]) |> IO.inspect()
    :test_gleam.main()
    IO.puts("-----")

    # 启动你的应用程序
    children = [
      # 这里可以启动其他子进程
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
