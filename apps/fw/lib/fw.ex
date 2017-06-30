defmodule Fw do
  use Application

  @interface :wlan0
  @kernel_modules ["8192cu", "hid-multitouch"]

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    # Define workers and child supervisors to be supervised
    children = [
      worker(Task, [fn -> init_kernel_modules() end], restart: :transient, id: Nerves.Init.KernelModules),
      worker(Task, [fn -> init_udevd() end], restart: :transient, id: Nerves.Init.Udevd),
      supervisor(Phoenix.PubSub.PG2, [Nerves.PubSub, [poolsize: 1]]),
      worker(Task, [fn -> init_network() end], restart: :transient, id: Nerves.Init.Wifi),
      worker(Task, [fn -> init_qtkiosk() end], restart: :transient, id: Nerves.Init.QtWK)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fw.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def init_kernel_modules() do
    Enum.each(@kernel_modules, & System.cmd("modprobe", [&1]))
  end

   def init_udevd() do   
    [{"/sbin/udevd", ["--daemon"]},
     {"udevadm", ["trigger", "--type=subsystems", "--action=add"]},
     {"udevadm", ["trigger", "--type=devices", "--action=add"]},
     {"udevadm", ["settle", "--timeout=30"]}]
    |> Enum.each(fn ({cmd, params}) ->
        System.cmd(cmd, params)
    end)
  end

  def init_network() do
    opts = Application.get_env(:fw, @interface)
    Nerves.InterimWiFi.setup(@interface, opts)
  end

  def init_qtkiosk() do
     System.cmd("qt-webkit-kiosk", ["-c", "/etc/phoenix_kiosk.ini"])
  end
  
end
