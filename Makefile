# ======================================================================
#          CHIBIWEBSERVER UNIVERSAL DEPLOYMENT & INSTALLER WRAPPER
# ======================================================================

TARGET_BASE = chibiwebserver
TARGET_DIR  = /usr/local/bin

# Определение архитектуры процессора текущей машины
ARCH := $(shell uname -m)

# Имена бинарных файлов в релизных пакетах
BIN_X86  = $(TARGET_BASE)_x86_64
BIN_ARM  = $(TARGET_BASE)_arm64

.PHONY: all install uninstall clean

# По умолчанию выводит подсказку по установке
all:
	@echo "======================================================================"
	@echo " ChibiWebServer Deployment Tool"
	@echo "======================================================================"
	@echo " Detected Architecture: $(ARCH)"
	@echo ""
	@echo " Available Commands:"
	@echo "   sudo make install     - Install and rename the binary for your CPU"
	@echo "   sudo make uninstall   - Remove the web server from the system"
	@echo "======================================================================"

# Умная установка бинарного файла с автоматическим переименованием под архитектуру хоста
install:
	@echo "=== Starting ChibiWebServer Installation ==="
	@mkdir -p $(TARGET_DIR)
	@if [ "$(ARCH)" = "x86_64" ]; then \
		if [ -f "$(BIN_X86)" ]; then \
			cp $(BIN_X86) $(TARGET_DIR)/$(TARGET_BASE); \
			chmod +x $(TARGET_DIR)/$(TARGET_BASE); \
			echo "-> Successfully deployed and renamed x86_64 binary to $(TARGET_DIR)/$(TARGET_BASE)"; \
		else \
			echo "[ERROR] Release binary '$(BIN_X86)' not found in current directory!"; \
			exit 1; \
		fi; \
	elif [ "$(ARCH)" = "aarch64" ] || [ "$(ARCH)" = "arm64" ]; then \
		if [ -f "$(BIN_ARM)" ]; then \
			cp $(BIN_ARM) $(TARGET_DIR)/$(TARGET_BASE); \
			chmod +x $(TARGET_DIR)/$(TARGET_BASE); \
			echo "-> Successfully deployed and renamed ARM64 binary to $(TARGET_DIR)/$(TARGET_BASE)"; \
		else \
			echo "[ERROR] Release binary '$(BIN_ARM)' not found in current directory!"; \
			exit 1; \
		fi; \
	else \
		echo "[ERROR] Unsupported hardware architecture: $(ARCH)"; \
		exit 1; \
	fi
	@echo "=== Installation Completed Successfully ==="

# Полное удаление сервера из системных папок
uninstall:
	@echo "=== Removing ChibiWebServer ==="
	rm -f $(TARGET_DIR)/$(TARGET_BASE)
	@echo "-> Binary removed from $(TARGET_DIR)/$(TARGET_BASE)"
	@echo "=== Uninstallation Completed ==="

# Очистка локальных остатков
clean:
	@echo "Nothing to clean in binary deployment package."
