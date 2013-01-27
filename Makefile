## Makefile fuers HMWorld:



# Variablen und Flags
# Version des Pakets
VERSION        = 0.3

# Name des Pakets
NAMESPACE       = rpg

# Name der Library
LIB_NAME       = librpg


# Quelldateien nur fuer das Spiel
SRCS           = main.vala

LIBRARY        = $(NAMESPACE)-$(VERSION)

# Quelltestdateien nur fuer Tests
TSRCS          = main.vala


# ausfuehrbares Ziel
TARGET                   = $(LIBRARY).o

SHARED_LIBRARY_TARGET    = $(LIB_NAME).so.$(VERSION)

STATIC_LIBRARY_TARGET    = $(LIB_NAME).a.$(VERSION)

TYPELIB_TARGET           = $(NAMESPACE)-$(VERSION).typelib

GIR_TARGET               = $(NAMESPACE)-$(VERSION).gir

VAPI_TARGET              = $(LIBRARY).vapi

HEADER_TARGET            = $(LIBRARY).h

PKGCONFIG_TARGET         = $(LIBRARY).pc


# Pakete
PACKAGES      = Sxml-0.1 gee-1.0 gio-2.0 posix gdk-pixbuf-2.0 json-glib-1.0
# C-Compileranweisungen
CFLAGS        = -lm # -lglut -lSDL_image

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

STATIC_LIBRARY_DIR   = $(LIB_DIR)
# Headerverzeichniss
HEADER_DIR    = $(LIB_DIR)
# Verzeichnis fuer erzeuge Binaries
BIN_DIR              = $(LIB_DIR)
# Verzeichnis fuer Doku
DOC_DIR              = doc/
# Verzeichnis fuer Doku
TST_DOC_DIR          = test/doc/
# Verzeichnis fuer Temporaere Dateien
TMP_DIR		         = tmp/


# Vala-Compiler
VC            = valac
# Gir-Compiler
GC            = g-ir-compiler
# Valadoc
VD            = valadoc


# Allgemeine Quelldateien mit Pfad
ASRC_FILES                 = $(wildcard src/*.vala) $(wildcard src/Gdk/*.vala) $(wildcard src/XML/*.vala)
# Quelldateien mit Pfad
SRC_FILES                  = $(ASRC_FILES)
# Test-Quelldateien mit Pfad
TSRC_FILES                 = $(ASRC_FILES)
# Zieldatei mit Pfad
TARGET_FILE                = $(TARGET:%=$(BIN_DIR)%)

TYPELIB_TARGET_FILE        = $(TYPELIB_TARGET:%=$(TYPELIB_DIR)%)

VAPI_TARGET_FILE           = $(VAPI_TARGET:%=$(LIB_DIR)%)

SHARED_LIBRARY_TARGET_FILE = $(SHARED_LIBRARY_TARGET:%=$(SHARED_LIBRARY_DIR)%)

STATIC_LIBRARY_TARGET_FILE = $(STATIC_LIBRARY_TARGET:%=$(STATIC_LIBRARY_DIR)%)

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
							--enable-experimental                     \
							--enable-experimental-non-null
# Alle g-ir-compiler obtionen
TYPELIB_COMP              = \
							--shared-library=$(SHARED_LIBRARY_TARGET) \
							--output=$(TYPELIB_TARGET)                \
							$(GIR_TARGET)                             \
# Alle Kombilerobtionen fuer shared-library
SHARED_LIBRARY_COMP   = \
							-o $(SHARED_LIBRARY_TARGET_FILE)          \
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
							--enable-experimental                     \
							--enable-experimental-non-null

# STATIC_LIBRARY_COMP = \
# 							ar                                        \
# 							rvs                                       \
# 							$(STATIC_LIBRARY_TARGET_FILE)             \
#							$(TARGET_FILE)

TEST_COMP   = \
							$(VAPI_TARGET_FILE)                       \
							--vapidir=$(VAPI_DIR)                     \
							$(PKG_FLAGS)                              \
							$(CC_FLAGS)                               \
							test/main.vala                            \
							-X lib/$(SHARED_LIBRARY_TARGET)           \
							-X -I$(LIB_DIR)                           \
							-o test.o                                 \
							--enable-experimental                     \
							--enable-experimental-non-null

DEBUG_COMP   = \
							-g                                        \
							--save-temps                              \
							-o $(TARGET_FILE)                         \
							--vapidir=$(VAPI_DIR)                     \
							$(PKG_FLAGS)                              \
							$(CC_FLAGS)                               \
							$(SRC_FILES)                              \
							test/main.vala                            \
							--enable-experimental                     \
							--enable-experimental-non-null

# Targets

.PHONY: all run dirs help clean test doc

## * make (all): Programm compilieren
all: dirs shared_library typelib
## * make install: Programm installieren
install:
	@sudo cp -u ./$(SHARED_LIBRARY_TARGET_FILE) /usr/lib/$(SHARED_LIBRARY_TARGET)		# .so
	@sudo cp -u ./$(HEADER_TARGET_FILE) /usr/include/$(HEADER_TARGET)					# .h
	@sudo cp -u ./$(VAPI_TARGET_FILE) /usr/share/vala/vapi/$(VAPI_TARGET)				# .vapi
	@sudo cp -u ./$(GIR_TARGET_FILE) /usr/share/gir-1.0/$(GIR_TARGET)					# .gir
	@sudo cp -u ./$(TYPELIB_TARGET_FILE) /usr/lib/girepository-1.0/$(TYPELIB_TARGET)	# .typelib
	@sudo cp -u ./$(PKGCONFIG_TARGET) /usr/lib/pkgconfig/$(LIBRARY).pc	                    # .pc //TODO fixme for debian
## * make unstall: Programm deinstallieren
unstall:
	@sudo rm -f /usr/lib/$(SHARED_LIBRARY_TARGET)
	@sudo rm -f /usr/include/$(HEADER_TARGET)
	@sudo rm -f /usr/share/vala/vapi/$(VAPI_TARGET)
	@sudo rm -f /usr/share/gir-1.0/$(GIR_TARGET)
	@sudo rm -f /usr/lib/girepository-1.0/$(TYPELIB_TARGET)
	@sudo rm -f /usr/lib/pkgconfig/$(LIBRARY).pc

## * make run: Library compilieren und node ausfuehren
run: all
	@echo "Running node src/main.js..."
	./run.sh;
## * make run-test: Test ausführen
run-test: all
	@echo "Running node src/main.js..."
	./test.o;
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
## * make static_library:  
#static_library: object
#	@echo "Compiling static_library:\n$(STATIC_LIBRARY_COMP)\n";  \
#	$(STATIC_LIBRARY_COMP)                
## * make typelib:  
typelib: shared_library
	@echo "Compiling Typelib:\n$(GC) $(TYPELIB_COMP)\n";  \
	cd $(GIR_DIR);                                        \
	$(GC) $(TYPELIB_COMP)                                 \
## * make c: Generate C-Files
c: dirs $(SRC_FILES)
	@echo "Compiling Binary..."
	@$(VC) $(COMP) -C
## * make doc: Dokumentation generieren
doc: $(SRC_FILES)
	@echo "Generating Documentation..."
	@rm $(DOC_DIR) -rf
	@$(VD) -o $(DOC_DIR) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES) --package-name $(LIBRARY) --package-version=$(VERSION) --enable-experimental
	@gnome-open ./doc/index.html

## * make doc-internal: Dokumentation generieren, inkl. nicht oeffentlicher Bereiche
doc-internal: $(SRC_FILES)
	@echo "Generating internal Documentation"
	@$(VD) -o $(DOC_DIR) --vapidir=$(VAPI_DIR) $(PKG_FLAGS) $(CC_FLAGS) $(SRC_FILES) --package-name $(NAMESPACE) --package-version=$(VERSION) --private --internal --importdir=$(TST_DOC_DIR) #fix importdir
	@gnome-open ./doc/index.html

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

## * Fuehrt das Testprogramm aus.
test: dirs all
	@echo "Testing.."
	@echo
	$(VC) $(TEST_COMP)
## * make debug: fuehrt das Testprogramm mit Debuggingtools aus.
debug: dirs $(SRC_FILES)
	@echo "Debuging.."
	@$(VC) $(DEBUG_COMP)
	@nemiver $(TARGET_FILE)
	#gdb $(TARGET_FILE)