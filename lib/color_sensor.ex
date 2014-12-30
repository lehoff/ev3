defmodule EV3.ColorSensor do

  @path_start "/sys/class/msensor/sensor"
  @color_list [{"0", :nothing}, {"1", :black}, {"2", :blue}, {"3", :green},
                {"4", :yellow}, {"5", :red}, {"6", :white}, {"7", :brown}]
  @mode_list [{"COL-REFLECT", :col_reflect}, {"COL-AMBIENT", :col_ambient},
              {"COL-COLOR", :col_color}, {"REF-RAW", :ref_raw}, {"RGB-RAW", :rgb_raw},
              {"COL-CAL", :col_cal}]
  
  defmodule State do
    defstruct id: 0, port_name: :undefined
  end
  
  def start_link(id, port_name) do
    ^port_name = id_port_name id
    "ev3-uart-29" = id_name id
    Agent.start_link(fn() -> %State{id: id, port_name: port_name} end)
  end

  def mode(sensor) do
    Agent.get(sensor,
      fn s ->
        id_path(s.id, "mode") |> EV3.Util.read! |> mode_from_string
      end)
  end
  
  def set_mode(sensor, mode) do
    Agent.cast(sensor,
      fn s ->
        id_path(s.id, "mode") |> EV3.Util.write! mode_to_string(mode)
      end)
  end

  def value(sensor) do
    case mode(sensor) do
      :col_color ->
        Agent.get(sensor,
          fn s ->
            id_path(s.id, "value0") |> EV3.Util.read! |> color_from_string
          end)
    end
  end
                   
  
  # Helper functions
  defp id_port_name id do
    id_path(id, "port_name") |> EV3.Util.read!  |> EV3.Util.port_name_from_string
  end

  defp id_path id, attr do
    @path_start <> "#{Integer.to_string id}/" <> attr
  end
  
  defp id_name id do
    id_path(id, "name") |> EV3.Util.read!
  end

  defp mode_from_string(s) do
    {_, m} = List.keyfind(@mode_list, s, 0)
    m
  end

  defp mode_to_string(m) do
    {s, _} = List.keyfind(@mode_list, m, 1)
    s
  end
  
  defp color_from_string(s) do
    {_,c} = List.keyfind(@color_list, s, 0)
    c
  end

  defp color_to_string(c) do
    {s, _} = List.keyfind(@color_list, c, 1)
    s
  end
  
end
