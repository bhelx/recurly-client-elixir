defmodule Recurly.XML.Types do
  @moduledoc """
  Module for working with xml types. Mostly useful for internal use.
  """

  @primitive_types ~w(string integer float boolean)a

  @doc """
  Returns a list of atoms of primitive xml types
  """
  @spec primitives() :: list(atom)
  def primitives, do: @primitive_types

  @doc """
  Checks whether the given atom is an xml primitive
  """
  @spec primitive?(atom) :: boolean
  def primitive?(type) do
    Enum.member?(@primitive_types, type)
  end
end
