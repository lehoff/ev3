defmodule EV3.Util do

  def read! path do
    File.read!(path) |> String.strip
  end

  def write! path, content do
    File.write! path, content
  end
  
  def port_name_from_string str do
    String.to_atom(str)
  end

  def port_name_to_string(:in1), do: "in1"
  def port_name_to_string(:in2), do: "in2"
  def port_name_to_string(:in3), do: "in3"
  def port_name_to_string(:in4), do: "in4"    
  def port_name_to_string(:outA), do: "outA"    
  def port_name_to_string(:outB), do: "outB"    
  def port_name_to_string(:outC), do: "outC"    
  def port_name_to_string(:outD), do: "outD"    
  
end
