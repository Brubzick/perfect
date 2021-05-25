test: test_CPU.v CPU.v PC.v InstructionRAM.v Register.v contrl_unit.v alu.v contrl2.v EXM.v MainMemory.v MEMR.v REX.v pc_transfer.v
	iverilog -o test.vvp test_CPU.v CPU.v PC.v InstructionRAM.v Register.v contrl_unit.v alu.v contrl2.v EXM.v MainMemory.v MEMR.v REX.v pc_transfer.v

clean: 
	rm test.vvp