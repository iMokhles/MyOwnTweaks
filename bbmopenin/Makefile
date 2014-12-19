GO_EASY_ON_ME = 1
export SDKVERSION=8.0
TARGET_IPHONEOS_DEPLOYMENT_VERSION = 7.0
ADDITIONAL_CFLAGS = -fobjc-arc

include theos/makefiles/common.mk

TWEAK_NAME = BBMOpenIN
BBMOpenIN_FILES = Tweak.xm $(wildcard *.m)
BBMOpenIN_FRAMEWORKS = UIKit Foundation CoreGraphics QuartzCore CoreImage Accelerate AVFoundation AudioToolbox MobileCoreServices Social Accounts MediaPlayer ImageIO

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += bbmopenin
include $(THEOS_MAKE_PATH)/aggregate.mk