defmodule Mix.Tasks.RunAll do
  use Mix.Task

  def run(_args) do
    Mix.Task.run("")
  end
end

defmodule Gleam.Config do
  def project_path() do
    "gleam/test_gleam/"
  end

  def gleam_erlang_path() do
    "gleam_erlang"
  end
end

defmodule Mix.Tasks.Gleam.Run do
  import Gleam.Config
  use Mix.Task

  def run(_args) do
    System.cmd("gleam", ["run"], into: IO.stream(), cd: project_path())
  end
end

defmodule Mix.Tasks.Gleam.Clean do
  import Gleam.Config
  use Mix.Task

  def run(_args) do
    System.cmd("gleam", ["clean"], into: IO.stream(), cd: project_path())
    File.rm_rf!(gleam_erlang_path())
  end
end

defmodule Mix.Tasks.Gleam.Build do
  @moduledoc "Compile the gleam project and copy the resulting erlang code to the current `gleam_erlang` directory"
  @shortdoc "Build gleam project to current dir"

  import Gleam.Config
  use Mix.Task

  @impl true
  def run(args) do
    mode =
      cond do
        "prod" in args ->
          :prod

        "dev" in args ->
          :de

        true ->
          :dev
      end

    IO.puts("gleam build mode: #{Atom.to_string(mode)}")

    # args |> IO.inspect()
    # Mix.shell().cmd(~s(gleam export erlang-shipment), cd: project_path())
    # gleam compile-package --target erlang --no-beam --package . --out out/ --lib   lib/

    case mode do
      :prod ->
        System.cmd("gleam", ["export", "erlang-shipment"], into: IO.stream(), cd: project_path())

      :dev ->
        System.cmd("gleam", ["build", "--target", "erlang"],
          into: IO.stream(),
          cd: project_path()
        )
    end

    dir = Path.join([project_path(), "build/#{Atom.to_string(mode)}/erlang/"])
    # dir = "gleam/test_gleam/build/#{Atom.to_string(mode)}/erlang/"

    dirs =
      File.ls!(dir)
      |> Enum.map(fn n -> {Path.join([dir, n, "_gleam_artefacts"]), n} end)
      |> Enum.filter(fn e -> File.exists?(elem(e, 0)) end)

    # dirs |> IO.inspect()
    dirs
    |> Enum.map(fn {path, name} ->
      dir_name = Path.join([gleam_erlang_path(), name])
      File.mkdir_p!(dir_name)

      File.ls!(path)
      |> Enum.filter(fn n -> (String.split(n, ".") |> Enum.at(-1)) in ["erl"] end)
      |> Enum.filter(fn n -> n != "gleam@@compile.erl" end)
      |> Enum.map(fn f ->
        File.cp!(Path.join([path, f]), Path.join([dir_name, f]))
        Path.join([dir_name, f])
      end)
    end)
    |> Enum.flat_map(& &1)
    |> Enum.map(&File.exists?(&1))
    |> Enum.all?(&(&1 == true))

    # |> IO.inspect()

    # for {path, name} <- dirs do
    #   dir_name = Path.join([gleam_erlang_path(), name])
    #   # dir_name = "erlang/" <> name
    #   File.mkdir_p!(dir_name)

    #   File.ls!(path)
    #   |> Enum.filter(fn n -> (String.split(n, ".") |> Enum.at(-1)) in ["erl"] end)
    #   |> Enum.filter(fn n -> n != "gleam@@compile.erl" end)
    #   |> Enum.each(fn f ->
    #     File.cp!(Path.join([path, f]), Path.join([dir_name, Path.basename(f)]))
    #   end)
    # end

    # Process.sleep(1000)
    IO.puts("gleam build complete")
  end
end
