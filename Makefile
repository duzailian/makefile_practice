CC:=riscv-none-embed-gcc
LD:=riscv-none-embed-ld
OBJ_DUMP:=riscv-none-embed-objdump
OBJ_COPY:=riscv-none-embed-objcopy

CC_FLAGS:=-Wall -O1
LD_FLAGS:=

out_dir:=out/
src_dir:=src/
inc_dir:=inc/
obj_dir:=

ifndef V
Q:=@
endif

src-y:=$(shell find $(src_dir) -name *.c)
asm-y:=$(shell find $(src_dir) -name *.s)
elf-y:=$(out_dir)prj.elf
bin-y:=$(basename $(elf-y)).bin
obj-y:=$(src-y:%.c=$(out_dir)%.o) $(asm-y:%.s=$(out_dir)%.o)
dep-y:=$(obj-y:%.o=%.d)

-include $(dep-y)

lds-y:=default.lds
LD_FLAGS += -T $(lds-y) -Map=$(out_dir)prj.map
CC_FLAGS += $(addprefix -I,$(inc_dir))

src_dir:=$(dir $(src-y))

mkdir:=$(dir $(obj-y))

Makfile:

$(mkdir):
	$Qecho mkdir:$@ ...
	$Qmkdir -p $@

$(out_dir)%.o:%.s | $(mkdir)
	$Qecho build $< ...
	$Q$(CC)  -MMD -c $(CC_FLAGS) $< -o $@

$(out_dir)%.o:%.c | $(mkdir)
	$Q echo  build $< ...
	$Q $(CC) -MMD -c $(CC_FLAGS) $< -o $@

$(elf-y): $(obj-y)
	$Q echo linking ...
	$Q $(LD) $^ $(LD_FLAGS) -o $@

dsm: $(elf-y)
	$Q $(OBJ_DUMP) -S -D $<  > $(elf-y:%.elf=%.dump)
.PHONY : dsm

$(bin-y): $(elf-y)
	$Q $(OBJ_COPY) $< -O binary $@
.PHONY : $(bin-y)

all: dsm $(bin-y)
.PHONY : all
.DEFAULT_GOAL = all

clean:
	rm -rf $(out_dir)
.PHONY : clean


