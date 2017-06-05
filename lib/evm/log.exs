Code.require_file("lib/evm/opcodes.exs")
Code.require_file("lib/evm/utils.exs")

defmodule EVM.Log do
  use EVM.Opcodes
  use EVM.Utils

  def step(stack, code, program_counter, opcode) do
    log_opcode(opcode)

    if atom_to_opcode(:sstore) == opcode do
      log_store_value(stack)
    end

    if is_push_opcode(opcode) do
      log_push_value(code, program_counter, opcode)
    end
  end

  def log_opcode(opcode) do
    log @opcodes[opcode]
      |> Atom.to_string
      |> String.upcase
  end

  def log_store_value(stack) do
    {value, _} = stack_pop(stack)
    log "VALUE: " <> pretty_encode(value)
  end

  def log_push_value(code, program_counter, opcode) do
    value = value_at(code, program_counter, opcode)
    log "VALUE: " <> pretty_encode(value)
  end

  def log(value) do
    IO.puts(value)
  end
end
