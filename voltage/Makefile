ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = Voltage
Voltage_FILES = Voltage.mm
Voltage_INSTALL_PATH = /Library/PreferenceBundles
Voltage_FRAMEWORKS = UIKit
Voltage_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Voltage.plist$(ECHO_END)
