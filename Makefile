FIRMWARE_BIN_FILE=massdrop_alt_nicomro.bin

default:
	@echo 'make clean     : delete ${FIRMWARE_BIN_FILE}'
	@echo 'make clean-all : delete all generated files'
	@echo 'make compile   : use QMK to create ${FIRMWARE_BIN_FILE}'
	@echo 'make flash     : flash ${FIRMWARE_BIN_FILE} into the keyboard'

.PHONY: clean clean-all compile flash default

clean:
	rm -f ${FIRMWARE_BIN_FILE}

clean-all:
	rm -rf ${FIRMWARE_BIN_FILE} mdloader_mac applet-flash-samd51j18a.bin

compile: clean ${FIRMWARE_BIN_FILE}

flash: applet-flash-samd51j18a.bin mdloader_mac ${FIRMWARE_BIN_FILE}
	./mdloader_mac --first --download ${FIRMWARE_BIN_FILE} --restart

${FIRMWARE_BIN_FILE}:
	test "$${QMK_HOME}"
	qmk compile -kb massdrop/alt -km nicomro
	mv ${QMK_HOME}/${FIRMWARE_BIN_FILE} ./

mdloader_mac:
	wget https://github.com/Massdrop/mdloader/releases/download/1.0.4/mdloader_mac
	chmod u+x mdloader_mac

applet-flash-samd51j18a.bin:
	wget https://github.com/Massdrop/mdloader/releases/download/1.0.4/applet-flash-samd51j18a.bin