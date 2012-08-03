## Makefile fuers Harvestmoon-Projekt:

export LD_LIBRARY_PATH := $(shell pwd)/lib
export GI_TYPELIB_PATH := $(shell pwd)/lib

# Variablen und Flags
# Version des Pakets
VERSION        = 0.1

# Name des Pakets
PKG_NAME       = Hmwd

# Quelldateien nur fuer das Spiel
SRCS           = main.vala

LIBRARY        = $(PKG_NAME)-$(VERSION)

# Quelltestdateien nur fuer Tests
TSRCS          = main.vala tileset.vala ClutterTest.vala


# ausfuehrbares Ziel
TARGET                   = $(LIBRARY).o
# ausfuehrbares Ziel
SHARED_LIBRARY_TARGET    = $(LIBRARY).so

TYPELIB_TARGET           = $(LIBRARY).typelib

GIR_TARGET               = $(LIBRARY).gir

VAPI_TARGET              = $(LIBRARY).vapi

HEADER_TARGET            = $(LIBRARY).h


# Pakete
PACKAGES      = gl glu glut sdl sdl-image cairo libxml-2.0 gee-1.0 gio-2.0 posix clutter-1.0 clutter-gtk-1.0
# C-Compileranweisungen
CFLAGS        = -lglut -lSDL_image -lm


# Quellverzeichnis
SRC_DIR              = src/
# Test-Quellverzeichnis
TSRC_DIR             = test/
# Vapiverzeichnis
VAPI_DIR             = vapi/

LIB_DIR              = lib/
# Girverzeichnis
GIR_DIR              = $(LIB_DIR)
# Typelibverzeichnis
TYPELIB_DIR          = $(LIB_DIR)
# Linkverzeichnis
SHARED_LIBRARY_DIR   = $(LIB_DIR)
# Headerverzeichniss
HEADER_DIR    = $(LIB_DIR)
# Verzeichnis fuer erzeuge Binaries
BIN_DIR              = bin/
# Verzeichnis fuer Doku
DOC_DIR              = doc/
# Verzeichnis fuer Doku
TST_DOC_DIR          = test/doc/
# Öffentliches Verzeichnis für die Dokumentationsveröffentlichung
PUB_DIR              = ~/Dropbox/Public/hmp/
# Verzeichnis fuer Temporaere Dateien
TMP_DIR		         = tmp/


# Bazaar-Repository
BZR_REPO      = bzr+ssh://bazaar.launchpad.net/%2Bbranch/hmproject/0.1/
# Vala-Compiler
VC            = valac
# Gir-Compiler
GC            = g-ir-compiler
# Valadoc
VD            = valadoc
# Valadoc Driver
VDD           = 0.15.3
# Bazaar
BZR           = bzr


# Allgemeine Quelldateien mit Pfad
ASRC_FILES                 = $(wildcard src/*.vala) $(wildcard src/Clutter/*.vala) $(wildcard src/OpenGL/*.vala) $(wildcard src/Gdk/*.vala)
# Quelldateien mit Pfad
SRC_FILES                  = $(ASRC_FILES)
# Test-Quelldateien mit Pfad
TSRC_FILES                 = $(ASRC_FILES)
# Zieldatei mit Pfad
TARGET_FILE                = $(TARGET:%=$(BIN_DIR)%)

TYPELIB_TARGET_FILE        = $(TYPELIB_TARGET:%=$(TYPELIB_DIR)%)

VAPI_TARGET_FILE           = $(VAPI_TARGET:%=$(LIB_DIR)%)

SHARED_LIBRARY_TARGET_FILE = $(SHARED_LIBRARY_TARGET:%=$(SHARED_LIBRARY_DIR)%)

GIR_TARGET_FILE            = $(GIR_TARGET:%=$(GIR_DIR)%)

HEADER_TARGET_FILE         = $(HEADER_TARGET:%=$(HEADER_DIR)%)


# Paketflags
PKG_FLAGS             = $(PACKAGES:%=--pkg %)
# C-Flags
CC_FLAGS              = $(CFLAGS:%=-X %)
# Alle Kombilerobtionen
COMP                  = \
							-o $(TARGET_FILE)                         \
							--vapidir=$(VAPI_DIR)                     \
							$(PKG_FLAGS)                              \
							$(CC_FLAGS)                               \
							$(SRC_FILES)                              \
# Alle g-ir-compiler obtionen
TYPELIB_COMP              = \
							--shared-library=$(SHARED_LIBRARY_TARGET) \
							--output=$(TYPELIB_TARGET)                \
							$(GIR_TARGET)                             \
# Alle Kombilerobtionen fuer shared-library
SHARED_LIBRARY_COMP   = \
							-o $(SHARED_LIBRARY_TARGET_FILE)          \
							--enable-experimental	           	      \
							--library=$(LIBRARY)                      \
							-H $(HEADER_TARGET_FILE)                  \
							--girdir=$(GIR_DIR)                       \
							--gir=$(GIR_TARGET)                       \
							--vapidir=$(VAPI_DIR)                     \
							$(PKG_FLAGS)                              \
							-X -fPIC                                  \
							-X -shared                                \
							$(CC_FLAGS)                               \
							$(SRC_FILES)                              \

TEST_COMP   = \
							$(VAPI_TARGET_FILE)                       \
							--vapidir=$(VAPI_DIR)                     \
							$(PKG_FLAGS)                              \
							$(CC_FLAGS)                               \
							src/main.vala                             \
							-X $(SHARED_LIBRARY_TARGET)               \
							-X -I$(LIB_DIR)                           \
							-o test.o

# Targets

.PHONY: all run dirs pull commit commit-* push push-* help clean test

## * make (all): Programm compilieren
all: dirs shared_library typelib

## * make run: Library compilieren und node ausfuehren
run: all
	@echo "Running node src/main.js..."
	@run.sh
## * make run: Programm compilieren und ausfuehren
run-object: dirs object
	@echo "Running $(TARGET_FILE)..."
	$(TARGET_FILE)
## * make dirs: Noetige Verzeichnisse erstellen
dirs:
	@echo "Creating output directory..."
	@mkdir -p $(BIN_DIR) $(DOC_DIR) $(VAPI_DIR) $(GIR_DIR) $(TYPELIB_DIR) $(SHARED_LIBRARY_DIR)
## * make executable:  
object: dirs $(SRC_FILES)
	@echo "Compiling Binary:\n$(VC) $(COMP)\n"
	@$(VC) $(COMP)
## * make shared_library:  
shared_library: dirs $(SRC_FILES)
	@echo "Compiling shared library: ";
	@echo $(VC) $(SHARED_LIBRARY_COMP);
	@echo ;
	@$(VC) $(SHARED_LIBRARY_COMP)
	@mv -f $(GIR_TARGET) $(GIR_TARGET_FILE)
	@mv -f $(VAPI_TARGET) $(VAPI_TARGET_FILE)
## * make typelib:  
typelib: shared_library
	@echo "Compiling Typelib:\n$(GC) $(TYPELIB_COMP)\n";  \
	cd $(GIR_DIR);                                        \
	$(GC) $(TYPELIB_COMP)                                 \
## * make c: Generate C-Files
c: dirs $(SRC_FILES)
	@echo "Compiling Binary..."
	@$(VC) $(COMP) -C
## * make doc-test: Dokumentation fuer die Tests generieren, inkl. nicht oeffentlicher Bereiche
doc-test: $(SRC_FILES)
	@echo "Generating internal Documentation for Tests..."
	@$(VD) --driver $(VDD) -o $(TST_DOC_DIR) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(TSRC_FILES) --package-name $(PKG_NAME) --package-version=$(VERSION) --private --internal
## * make doc: Dokumentation generieren
doc: $(SRC_FILES)
	@echo "Generating Documentation..."
	@$(VD) --driver $(VDD) -o $(DOC_DIR) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES) --package-name $(PKG_NAME) --package-version=$(VERSION)
	@gnome-open ./doc/index.html

## * make doc-internal: Dokumentation generieren, inkl. nicht oeffentlicher Bereiche
doc-internal: $(SRC_FILES)
	@echo "Generating internal Documentation"
	@$(VD) --driver $(VDD) -o $(DOC_DIR) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES) --package-name $(PKG_NAME) --package-version=$(VERSION) --private --internal --importdir=$(TST_DOC_DIR) #fix importdir
	@gnome-open ./doc/index.html

## * make doc-publish: Zuvor generierte Doc veroeffentlichen
doc-publish: $(SRC_FILES)
	@mkdir -p $(PUB_DIR)
	@cp $(DOC_DIR) $(PUB_DIR) -r
	@gnome-open http://dl.dropbox.com/u/55722973/hmp/doc/index.html

## * make clean: Raeumt die erzeugten Dateien auf
clean:
	@echo "Cleaning up..."
	@rm -rf $(BIN_DIR)
	@rm -rf $(DOC_DIR)
	@rm -rf $(SRC_DIR)*.c
	@rm -rf $(SRC_DIR)/*/*.c
	@rm -rf $(TMP_DIR)
	@rm -rf $(TST_DOC_DIR)
	@rm -rf $(GIR_DIR)
	@rm -rf $(TYPELIB_DIR)
	@rm -rf $(SHARED_LIBRARY_DIR)
	@rm -rf core
## * make help: Diese Hilfe anzeigen
help:
	@grep '^##' 'Makefile' | sed -e 's/## //g'

## * Valadate aus dem Repo installieren, unfollstaendig, fehlerhaft.
install-valadate:
	@sudo apt-get install gobject-introspection -y
	@rm tmp -rf
	@mkdir tmp
	@git clone git://gitorious.org/~serbanjora/valadate/serbanjora-valadate.git ./tmp/
	@cd ./tmp && ./waf configure && ./waf install
## * Fuehrt das Testprogramm aus.
test: dirs all
	@echo "Testing.."
	@echo
	$(VC) $(TEST_COMP)
## * make debug: fuehrt das Testprogramm mit Debuggingtools aus.
debug: dirs $(SRC_FILES)
	@echo "Debuging.."
	@$(VC) -g --save-temps -o $(TARGET_FILE) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES)
	@nemiver $(TARGET_FILE)
	#gdb $(TARGET_FILE)