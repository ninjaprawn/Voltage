THEOS_DEVICE_IP = 192.168.1.120

include theos/makefiles/common.mk

TWEAK_NAME = Voltage
Voltage_FILES = Tweak.xm
Voltage_FRAMEWORKS = Foundation UIKit CoreGraphics AVFoundation MediaPlayer

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += voltage

after-install::
	install.exec "killall -9 SpringBoard"

include $(THEOS_MAKE_PATH)/aggregate.mk
