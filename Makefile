# Cubicraft RPG GBA - Makefile para devkitARM (devkitPro)
# Uso:  make        -> genera cubicraft.gba
#       make clean
ifeq ($(strip $(DEVKITARM)),)
$(error "Define DEVKITARM (instala devkitPro) o compila con el workflow de GitHub Actions")
endif

TARGET  := cubicraft
SOURCES := $(wildcard source/*.c)
OBJECTS := $(patsubst source/%.c,build/%.o,$(SOURCES))

PREFIX  := $(DEVKITARM)/bin/arm-none-eabi-
CC      := $(PREFIX)gcc
OBJCOPY := $(PREFIX)objcopy
GBAFIX  := $(shell which gbafix 2>/dev/null || echo $(DEVKITPRO)/tools/bin/gbafix)

ARCH    := -mthumb -mthumb-interwork
CFLAGS  := -O2 -Wall -mcpu=arm7tdmi -mtune=arm7tdmi -fomit-frame-pointer -fno-strict-aliasing -std=gnu99 $(ARCH)
LDFLAGS := $(ARCH) -specs=gba.specs -Wl,-Map,build/$(TARGET).map

.PHONY: all clean
all: $(TARGET).gba

$(TARGET).gba: build/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@
	-$(GBAFIX) $@ -t"CUBICRAFT" -c"CBCR" -m"01"
	@echo "ROM lista: $@  ($$(wc -c < $@) bytes)"

build/$(TARGET).elf: $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

build/%.o: source/%.c $(wildcard source/*.h) | build
	$(CC) $(CFLAGS) -c $< -o $@

build:
	mkdir -p build

clean:
	rm -rf build $(TARGET).gba
