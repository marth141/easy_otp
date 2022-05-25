defmodule Debug do
  def destroy_bikini_bottom() do
    EasyOtp.registry_read(EasyOtp.MyRegistry, EasyOtp.MyDynamicSupervisor)
    |> Enum.map(fn
      %{"module" => EasyOtp.Stack, "pid" => pid} ->
        EasyOtp.genserver_stack_stop(pid)

      %{"module" => EasyOtp.Counter, "pid" => pid} ->
        EasyOtp.agent_counter_stop(pid)
    end)
  end

  def make_bikini_bottom() do
    EasyOtp.genserver_stack_start(EasyOtp.MyRegistry, EasyOtp.MyDynamicSupervisor, "Spongebob")
    EasyOtp.genserver_stack_start(EasyOtp.MyRegistry, EasyOtp.MyDynamicSupervisor, "Patrick")
    EasyOtp.agent_counter_start(EasyOtp.MyRegistry, EasyOtp.MyDynamicSupervisor, "Squidward")
    EasyOtp.agent_counter_start(EasyOtp.MyRegistry, EasyOtp.MyDynamicSupervisor, "Mr. Krabs")
  end
end
