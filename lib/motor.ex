defmodule EV3.Motor do
  @path_start "/sys/class/tacho-motor/motor"

  defmodule State do
    defstruct id: 0, port_name: :undefined, type: :tacho
  end
    
  def start_link id, port_name, type do
    # @todo check that args are correct
    ^port_name = id_port_name id
    ^type = id_type id                                   
    Agent.start_link(fn() -> %State{id: id, port_name: port_name, type: type} end)
  end

  def position motor do
    Agent.get(motor,
      fn s ->
         id_path(s.id, "position") |> EV3.Util.read!
      end)
  end

  def pulses_per_second motor do
    Agent.get(motor,
      fn s ->
        id_path(s.id, "pulses_per_second") |> EV3.Util.read!
      end)
  end

  def set_duty_cycle_sp(motor, pct) do
    Agent.get(motor,
      fn s ->
        id_path(s.id, "duty_cycle_sp") |> EV3.Util.write! Integer.to_string(pct)
      end)
  end

  def duty_cycle_sp motor do
    Agent.get(motor,
      fn s ->
        id_path(s.id, "duty_cycle_sp") |> EV3.Util.read!
      end)
  end

  def run motor do
    Agent.get(motor,
      fn s ->
        id_path(s.id, "run") |> EV3.Util.write! "1"
      end)
  end

  def stop motor do
    Agent.get(motor,
      fn s ->
        id_path(s.id, "run") |> EV3.Util.write! "0"
      end)
  end
  




  
  # Private helper functions
  def id_port_name id do
    id_path(id, "port_name") |> EV3.Util.read!  |> EV3.Util.port_name_from_string
  end

  def id_path id, attr do
    @path_start <> "#{Integer.to_string id}/" <> attr
  end
  
  def id_type id do
    id_path(id, "type") |> EV3.Util.read!  |> type_from_string
  end

  def type_from_string(str), do: String.to_atom(str)

  
  
end



  
