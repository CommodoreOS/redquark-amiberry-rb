# Default platform is rpi3 / SDL1

ifeq ($(PLATFORM),)
	PLATFORM = rpi3
endif

#
# SDL1 targets
#
ifeq ($(PLATFORM),rpi3)
    CPU_FLAGS += -march=armv8-a -mfpu=neon-fp-armv8 -mfloat-abi=hard
    MORE_CFLAGS += -DARMV6T2 -DUSE_ARMNEON -DCAPSLOCK_DEBIAN_WORKAROUND -DUSE_SDL1
    MORE_CFLAGS += -I/opt/vc/include -I/opt/vc/include/interface/vmcs_host/linux -I/opt/vc/include/interface/vcos/pthreads
    LDFLAGS += -lbcm_host -lvchiq_arm -L/opt/vc/lib
    PROFILER_PATH = /home/pi/projects/amiberry
	
else ifeq ($(PLATFORM),rpi2)
    CPU_FLAGS += -march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard
    MORE_CFLAGS += -DARMV6T2 -DUSE_ARMNEON -DCAPSLOCK_DEBIAN_WORKAROUND -DUSE_SDL1
    MORE_CFLAGS += -I/opt/vc/include -I/opt/vc/include/interface/vmcs_host/linux -I/opt/vc/include/interface/vcos/pthreads
    LDFLAGS += -lbcm_host -lvchiq_arm -L/opt/vc/lib
    PROFILER_PATH = /home/pi/projects/amiberry
	
else ifeq ($(PLATFORM),rpi1)
    CPU_FLAGS += -march=armv6zk -mfpu=vfp -mfloat-abi=hard
    MORE_CFLAGS += -DCAPSLOCK_DEBIAN_WORKAROUND -DUSE_SDL1
    MORE_CFLAGS += -I/opt/vc/include -I/opt/vc/include/interface/vmcs_host/linux -I/opt/vc/include/interface/vcos/pthreads
    LDFLAGS += -lbcm_host -lvchiq_arm -L/opt/vc/lib
    PROFILER_PATH = /home/pi/projects/amiberry

else ifeq ($(PLATFORM),Pandora)
    CPU_FLAGS +=  -march=armv7-a -mfpu=neon -mfloat-abi=softfp
    MORE_CFLAGS += -DARMV6T2 -DUSE_ARMNEON -DPANDORA -DUSE_SDL1 -msoft-float
    PROFILER_PATH = /media/MAINSD/pandora/test
	
else ifeq ($(PLATFORM),xu4)
    CPU_FLAGS += -march=armv7ve -mcpu=cortex-a15.cortex-a7 -mtune=cortex-a15.cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard
    MORE_CFLAGS += -DARMV6T2 -DUSE_ARMNEON -DUSE_SDL1
    ifdef DEBUG
	    # Otherwise we'll get compilation errors, check https://tls.mbed.org/kb/development/arm-thumb-error-r7-cannot-be-used-in-asm-here
	    # quote: The assembly code in bn_mul.h is optimized for the ARM platform and uses some registers, including r7 to efficiently do an operation. GCC also uses r7 as the frame pointer under ARM Thumb assembly.
        MORE_CFLAGS += -fomit-frame-pointer
    endif

else ifeq ($(PLATFORM),android)
	CPU_FLAGS += -mfpu=neon -mfloat-abi=soft
	DEFS += -DANDROIDSDL
	ANDROID = 1
	HAVE_NEON = 1
	HAVE_SDL_DISPLAY = 1

#
# SDL2 targets
#	
else ifeq ($(PLATFORM),rpi3-sdl2)
USE_SDL2 = 1
    CPU_FLAGS += -march=armv8-a -mfpu=neon-fp-armv8 -mfloat-abi=hard
    MORE_CFLAGS += -DARMV6T2 -DUSE_ARMNEON -DCAPSLOCK_DEBIAN_WORKAROUND -DUSE_SDL2
    LDFLAGS += -lm
    PROFILER_PATH = /home/pi/projects/amiberry/amiberry-sdl2-prof
	
else ifeq ($(PLATFORM),rpi2-sdl2)
USE_SDL2 = 1
    CPU_FLAGS += -march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard
    MORE_CFLAGS += -DARMV6T2 -DUSE_ARMNEON -DCAPSLOCK_DEBIAN_WORKAROUND -DUSE_SDL2
    PROFILER_PATH = /home/pi/projects/amiberry/amiberry-sdl2-prof
	
else ifeq ($(PLATFORM),rpi1-sdl2)
USE_SDL2 = 1
    CPU_FLAGS += -march=armv6zk -mfpu=vfp -mfloat-abi=hard
    MORE_CFLAGS += -DCAPSLOCK_DEBIAN_WORKAROUND -DUSE_SDL2
    PROFILER_PATH = /home/pi/projects/amiberry/amiberry-sdl2-prof

else ifeq ($(PLATFORM),pine64-sdl2)
USE_SDL2 = 1
    CPU_FLAGS += -march=armv7-a -mfpu=vfpv3-d16 -mfloat-abi=hard
    MORE_CFLAGS += -DARMV6T2 -D__arm__ -DUSE_SDL2
    CC = arm-linux-gnueabihf-gcc
    CXX = arm-linux-gnueabihf-g++

else ifeq ($(PLATFORM),xu4-sdl2)
USE_SDL2 = 1
    CPU_FLAGS += -march=armv7ve -mcpu=cortex-a15.cortex-a7 -mtune=cortex-a15.cortex-a7 -mfpu=neon-vfpv4 -mfloat-abi=hard
    MORE_CFLAGS += -DARMV6T2 -DUSE_ARMNEON -DUSE_SDL2
    ifdef DEBUG
	    # Otherwise we'll get compilation errors, check https://tls.mbed.org/kb/development/arm-thumb-error-r7-cannot-be-used-in-asm-here
	    # quote: The assembly code in bn_mul.h is optimized for the ARM platform and uses some registers, including r7 to efficiently do an operation. GCC also uses r7 as the frame pointer under ARM Thumb assembly.
        MORE_CFLAGS += -fomit-frame-pointer
    endif
endif

#
# SDL1 options
#
ifndef USE_SDL2

NAME   = amiberry-sdl1-dev
RM     = rm -f
CC     ?= gcc
CXX    ?= g++
STRIP  ?= strip

PROG   = $(NAME)

all: $(PROG)

#DEBUG=1
#TRACER=1

#GEN_PROFILE=1
#USE_PROFILE=1

SDL_CFLAGS = `sdl-config --cflags`

DEFS +=  `xml2-config --cflags`
DEFS += -DAMIBERRY -DCPU_arm -DARMV6_ASSEMBLY
#DEFS += -DWITH_LOGGING

MORE_CFLAGS += -Isrc -Isrc/osdep -Isrc/threaddep -Isrc/include -Isrc/archivers
MORE_CFLAGS += -Wno-unused -Wno-format -DGCCCONSTFUNC="__attribute__((const))"
#MORE_CFLAGS += -fuse-ld=gold -fdiagnostics-color=auto
#MORE_CFLAGS += -mstructure-size-boundary=32
MORE_CFLAGS += -falign-functions=32
MORE_CFLAGS += -std=gnu++14

LDFLAGS += -lSDL -lpthread -lz -lSDL_image -lpng -lxml2 -lFLAC -lmpg123 -ldl -lmpeg2convert -lmpeg2
LDFLAGS += -lSDL_ttf -lguichan_sdl -lguichan

endif
#
# End of SDL1 options
#

#
# SDL2 options
#
ifdef USE_SDL2

NAME  = amiberry-sdl2-dev
RM      = rm -f
CC     ?= gcc
CXX    ?= g++
STRIP  ?= strip

PROG   = $(NAME)

all: guisan $(PROG)

guisan:
	$(MAKE) -C src/guisan

#DEBUG=1
#GEN_PROFILE=1
#USE_PROFILE=1

SDL_CFLAGS = `sdl2-config --cflags --libs`

DEFS += `xml2-config --cflags`
DEFS += -DAMIBERRY -DCPU_arm -DARMV6_ASSEMBLY
#DEFS += -DWITH_LOGGING

MORE_CFLAGS += -Isrc -Isrc/osdep -Isrc/threaddep -Isrc/include -Isrc/guisan/include -Isrc/archivers
MORE_CFLAGS += -fdiagnostics-color=auto
#MORE_CFLAGS += -mstructure-size-boundary=32
MORE_CFLAGS += -falign-functions=32
MORE_CFLAGS += -std=gnu++14

LDFLAGS += -lpthread -lz -lpng -lrt -lxml2 -lFLAC -lmpg123 -ldl -lmpeg2convert -lmpeg2
LDFLAGS += -lSDL2 -lSDL2_image -lSDL2_ttf -lguisan -Lsrc/guisan/lib

endif
#
# End of SDL2 options
#

#
# Common options
#
ifndef DEBUG
    MORE_CFLAGS += -Ofast -pipe
    MORE_CFLAGS += -fweb -frename-registers
    MORE_CFLAGS += -funroll-loops -ftracer -funswitch-loops
else
    MORE_CFLAGS += -g -rdynamic -funwind-tables -mapcs-frame -DDEBUG -Wl,--export-dynamic
endif

ifdef WITH_LOGGING
    MORE_CFLAGS += -DWITH_LOGGING
endif

ASFLAGS += $(CPU_FLAGS) -falign-functions=32

CXXFLAGS += $(SDL_CFLAGS) $(CPU_FLAGS) $(DEFS) $(MORE_CFLAGS)

ifdef GEN_PROFILE
    MORE_CFLAGS += -fprofile-generate=$(PROFILER_PATH) -fprofile-arcs -fvpt
endif
ifdef USE_PROFILE
    MORE_CFLAGS += -fprofile-use -fprofile-correction -fbranch-probabilities -fvpt
endif

OBJS =	\
	src/akiko.o \
	src/ar.o \
	src/aros.rom.o \
	src/audio.o \
	src/autoconf.o \
	src/blitfunc.o \
	src/blittable.o \
	src/blitter.o \
	src/blkdev.o \
	src/blkdev_cdimage.o \
	src/bsdsocket.o \
	src/calc.o \
	src/cd32_fmv.o \
	src/cd32_fmv_genlock.o \
	src/cdrom.o \
	src/cfgfile.o \
	src/cia.o \
	src/crc32.o \
	src/custom.o \
	src/def_icons.o \
	src/devices.o \
	src/disk.o \
	src/diskutil.o \
	src/drawing.o \
	src/events.o \
	src/expansion.o \
	src/fdi2raw.o \
	src/filesys.o \
	src/flashrom.o \
	src/fpp.o \
	src/fpp_native.o \
	src/fpp_softfloat.o \
	src/softfloat/softfloat.o \
	src/softfloat/softfloat_decimal.o \
	src/softfloat/softfloat_fpsp.o \
	src/fsdb.o \
	src/fsdb_unix.o \
	src/fsusage.o \
	src/gayle.o \
	src/gfxboard.o \
	src/gfxutil.o \
	src/hardfile.o \
	src/hrtmon.rom.o \
	src/ide.o \
	src/inputdevice.o \
	src/keybuf.o \
	src/main.o \
	src/memory.o \
	src/native2amiga.o \
	src/rommgr.o \
	src/rtc.o \
	src/savestate.o \
	src/scsi.o \
	src/statusline.o \
	src/traps.o \
	src/uaelib.o \
	src/uaeresource.o \
	src/zfile.o \
	src/zfile_archive.o \
	src/archivers/7z/7zAlloc.o \
	src/archivers/7z/7zBuf.o \
	src/archivers/7z/7zCrc.o \
	src/archivers/7z/7zCrcOpt.o \
	src/archivers/7z/7zDec.o \
	src/archivers/7z/7zIn.o \
	src/archivers/7z/7zStream.o \
	src/archivers/7z/Bcj2.o \
	src/archivers/7z/Bra.o \
	src/archivers/7z/Bra86.o \
	src/archivers/7z/LzmaDec.o \
	src/archivers/7z/Lzma2Dec.o \
	src/archivers/7z/BraIA64.o \
	src/archivers/7z/Delta.o \
	src/archivers/7z/Sha256.o \
	src/archivers/7z/Xz.o \
	src/archivers/7z/XzCrc64.o \
	src/archivers/7z/XzDec.o \
	src/archivers/dms/crc_csum.o \
	src/archivers/dms/getbits.o \
	src/archivers/dms/maketbl.o \
	src/archivers/dms/pfile.o \
	src/archivers/dms/tables.o \
	src/archivers/dms/u_deep.o \
	src/archivers/dms/u_heavy.o \
	src/archivers/dms/u_init.o \
	src/archivers/dms/u_medium.o \
	src/archivers/dms/u_quick.o \
	src/archivers/dms/u_rle.o \
	src/archivers/lha/crcio.o \
	src/archivers/lha/dhuf.o \
	src/archivers/lha/header.o \
	src/archivers/lha/huf.o \
	src/archivers/lha/larc.o \
	src/archivers/lha/lhamaketbl.o \
	src/archivers/lha/lharc.o \
	src/archivers/lha/shuf.o \
	src/archivers/lha/slide.o \
	src/archivers/lha/uae_lha.o \
	src/archivers/lha/util.o \
	src/archivers/lzx/unlzx.o \
	src/archivers/mp2/kjmp2.o \
	src/archivers/wrp/warp.o \
	src/archivers/zip/unzip.o \
	src/machdep/support.o \
	src/osdep/bsdsocket_host.o \
	src/osdep/cda_play.o \
	src/osdep/charset.o \
	src/osdep/fsdb_host.o \
	src/osdep/amiberry_hardfile.o \
	src/osdep/keyboard.o \
	src/osdep/mp3decoder.o \
	src/osdep/picasso96.o \
	src/osdep/writelog.o \
	src/osdep/amiberry.o \
	src/osdep/amiberry_filesys.o \
	src/osdep/amiberry_input.o \
	src/osdep/amiberry_gfx.o \
	src/osdep/amiberry_gui.o \
	src/osdep/amiberry_rp9.o \
	src/osdep/amiberry_mem.o \
	src/osdep/sigsegv_handler.o \
	src/sounddep/sound.o \
	src/osdep/gui/UaeRadioButton.o \
	src/osdep/gui/UaeDropDown.o \
	src/osdep/gui/UaeCheckBox.o \
	src/osdep/gui/UaeListBox.o \
	src/osdep/gui/InGameMessage.o \
	src/osdep/gui/SelectorEntry.o \
	src/osdep/gui/ShowHelp.o \
	src/osdep/gui/ShowMessage.o \
	src/osdep/gui/SelectFolder.o \
	src/osdep/gui/SelectFile.o \
	src/osdep/gui/CreateFilesysHardfile.o \
	src/osdep/gui/EditFilesysVirtual.o \
	src/osdep/gui/EditFilesysHardfile.o \
	src/osdep/gui/PanelPaths.o \
	src/osdep/gui/PanelQuickstart.o \
	src/osdep/gui/PanelConfig.o \
	src/osdep/gui/PanelCPU.o \
	src/osdep/gui/PanelChipset.o \
	src/osdep/gui/PanelCustom.o \
	src/osdep/gui/PanelROM.o \
	src/osdep/gui/PanelRAM.o \
	src/osdep/gui/PanelFloppy.o \
	src/osdep/gui/PanelHD.o \
	src/osdep/gui/PanelInput.o \
	src/osdep/gui/PanelDisplay.o \
	src/osdep/gui/PanelSound.o \
	src/osdep/gui/PanelMisc.o \
	src/osdep/gui/PanelSavestate.o \
	src/osdep/gui/main_window.o \
	src/osdep/gui/Navigation.o

ifndef USE_SDL2
OBJS += src/osdep/gui/sdltruetypefont.o
endif
	
ifeq ($(ANDROID), 1)
OBJS += src/osdep/gui/androidsdl_event.o
OBJS += src/osdep/gui/PanelOnScreen.o
OBJS += src/osdep/pandora_gfx.o
endif

OBJS += src/osdep/neon_helper.o

OBJS += src/newcpu.o
OBJS += src/newcpu_common.o
OBJS += src/readcpu.o
OBJS += src/cpudefs.o
OBJS += src/cpustbl.o
OBJS += src/cpuemu_0.o
OBJS += src/cpuemu_4.o
OBJS += src/cpuemu_11.o
OBJS += src/cpuemu_40.o
OBJS += src/cpuemu_44.o
OBJS += src/jit/compemu.o
OBJS += src/jit/compstbl.o
OBJS += src/jit/compemu_fpp.o
OBJS += src/jit/compemu_support.o

src/osdep/neon_helper.o: src/osdep/neon_helper.s
	$(CXX) $(CPU_FLAGS) -Wall -o src/osdep/neon_helper.o -c src/osdep/neon_helper.s

$(PROG): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(PROG) $(OBJS) $(LDFLAGS)
ifndef DEBUG
	$(STRIP) $(PROG)
endif

ASMS = \
	src/audio.s \
	src/autoconf.s \
	src/blitfunc.s \
	src/blitter.s \
	src/cia.s \
	src/custom.s \
	src/disk.s \
	src/drawing.s \
	src/events.s \
	src/expansion.s \
	src/filesys.s \
	src/fpp.s \
	src/fsdb.s \
	src/fsdb_unix.s \
	src/fsusage.s \
	src/gfxutil.s \
	src/hardfile.s \
	src/inputdevice.s \
	src/keybuf.s \
	src/main.s \
	src/memory.s \
	src/native2amiga.s \
	src/traps.s \
	src/uaelib.s \
	src/uaeresource.s \
	src/zfile.s \
	src/zfile_archive.s \
	src/machdep/support.s \
	src/osdep/picasso96.s \
	src/osdep/amiberry.s \
	src/osdep/amiberry_gfx.s \
	src/osdep/amiberry_mem.s \
	src/osdep/sigsegv_handler.s \
	src/sounddep/sound.s \
	src/newcpu.s \
	src/newcpu_common.s \
	src/readcpu.s \
	src/cpudefs.s \
	src/cpustbl.s \
	src/cpuemu_0.s \
	src/cpuemu_4.s \
	src/cpuemu_11.s \
	src/jit/compemu.s \
	src/jit/compemu_fpp.s \
	src/jit/compstbl.s \
	src/jit/compemu_support.s

genasm: $(ASMS)

clean:
	$(RM) $(PROG) $(OBJS) $(ASMS)

delasm:
	$(RM) $(ASMS)
	
bootrom:
	od -v -t xC -w8 src/filesys |tail -n +5 | sed -e "s,^.......,," -e "s,[0123456789abcdefABCDEF][0123456789abcdefABCDEF],db(0x&);,g" > src/filesys_bootrom.cpp
	touch src/filesys.cpp
