FIRMWARE_BIN_FILE=massdrop_alt_nicomro.bin
ROOT_DIRECTORY:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
FIRMWARE_DIRECTORY=${ROOT_DIRECTORY}/qmk_firmware

default:
	@echo 'make clean     : delete ${FIRMWARE_BIN_FILE}'
	@echo 'make clean-all : delete all generated files'
	@echo 'make compile   : use QMK to create ${FIRMWARE_BIN_FILE}'
	@echo 'make flash     : flash ${FIRMWARE_BIN_FILE} into the keyboard'

.PHONY: check check_qmk_cli clean clean-all compile default flash qmk-setup

check:
	@echo "ROOT_DIRECTORY:     $(ROOT_DIRECTORY)"
	@echo "FIRMWARE_DIRECTORY: $(FIRMWARE_DIRECTORY)"

check_qmk_cli:
	which qmk

clean:
	rm -f ${FIRMWARE_BIN_FILE}

clean-all:
	rm -rf ${FIRMWARE_BIN_FILE} mdloader-Linux.zip mdloader

compile: clean ${FIRMWARE_BIN_FILE}

flash: mdloader ${FIRMWARE_BIN_FILE}
	./mdloader --first --download ${FIRMWARE_BIN_FILE} --restart

qmk-setup: check_qmk_cli
	qmk setup --home ${FIRMWARE_DIRECTORY} --branch nicomro nicomro/qmk_firmware
	sudo cp ${FIRMWARE_DIRECTORY}/util/udev/50-qmk.rules /etc/udev/rules.d/

${FIRMWARE_BIN_FILE}: check_qmk_cli
	qmk clean && qmk compile -kb massdrop/alt -km nicomro
	mv ${FIRMWARE_DIRECTORY}/${FIRMWARE_BIN_FILE} ./

${FIRMWARE_DIRECTORY}:
	git clone git@github.com:nicomro/qmk_firmware.git ${FIRMWARE_DIRECTORY}

mdloader:
	wget /releases/download/1.0.7/mdloader-Linux.zip
	unzip mdloader-Linux.zip
	chmod +x mdloader
	rm mdloader-Linux.zip
