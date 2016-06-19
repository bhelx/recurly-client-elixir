defmodule Recurly.XML.Types do
  @moduledoc """
  Module for working with xml types. Mostly useful for internal use.
  """

  @primitive_types ~w(string integer float boolean)a

  @doc """
  Returns a list of atoms of primitive xml types
  """
  def primitives, do: @primitive_types

  @doc """
  Checks whether the given atom is an xml primitive
  """
  def primitive?(type) do
    Enum.member?(@primitive_types, type)
  end
end
