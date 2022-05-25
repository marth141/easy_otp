defmodule EasyOtpTest do
  use ExUnit.Case
  doctest EasyOtp

  setup_all do
    spongebob =
      EasyOtp.genserver_stack_start(
        EasyOtp.MyRegistry,
        EasyOtp.MyDynamicSupervisor,
        "Spongebob",
        registry_value: "Fry Cooking"
      )

    patrick =
      EasyOtp.agent_counter_start(
        EasyOtp.MyRegistry,
        EasyOtp.MyDynamicSupervisor,
        "Patrick",
        registry_value: "Jellyfishing"
      )

    {:ok, genserver: spongebob, agent: patrick}
  end

  test "start and stop genserver", _setup do
    assert {:ok, pid} =
             EasyOtp.genserver_stack_start(
               EasyOtp.MyRegistry,
               EasyOtp.MyDynamicSupervisor,
               "Plankton",
               registry_value: "Espionage"
             )

    assert :ok == EasyOtp.genserver_stack_stop(pid)
  end

  test "add, read, and remove element from genserver", setup do
    assert {:ok, pid} = setup[:genserver]

    assert :ok == EasyOtp.genserver_stack_push(pid, :world)
    assert [:world, :hello] == EasyOtp.genserver_stack_read(pid)
    assert :world == EasyOtp.genserver_stack_pop(pid)
  end

  test "start and stop agent", _setup do
    assert {:ok, pid} =
             EasyOtp.agent_counter_start(
               EasyOtp.MyRegistry,
               EasyOtp.MyDynamicSupervisor,
               "Squidward",
               registry_value: "Clarinet"
             )

    assert :ok == EasyOtp.agent_counter_stop(pid)
  end

  test "read agent state", setup do
    assert {:ok, pid} = setup[:agent]

    state = EasyOtp.agent_counter_read(pid)

    assert is_number(state)
  end

  test "increment agent", setup do
    assert {:ok, pid} = setup[:agent]

    assert :ok == EasyOtp.agent_counter_increment(pid)
  end

  test "registry read", _setup do
    assert [
             %{
               "module" => EasyOtp.Stack,
               "registry_key" => "Spongebob"
             },
             %{
               "module" => EasyOtp.Counter,
               "registry_key" => "Patrick"
             }
           ] = EasyOtp.registry_read(EasyOtp.MyRegistry, EasyOtp.MyDynamicSupervisor)
  end

  test "registry lookup", _setup do
    assert [{_some_pid, "Fry Cooking"}] = EasyOtp.registry_lookup(EasyOtp.MyRegistry, "Spongebob")
    assert [{_some_pid, "Jellyfishing"}] = EasyOtp.registry_lookup(EasyOtp.MyRegistry, "Patrick")
  end
end
