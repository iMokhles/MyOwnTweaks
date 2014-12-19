include theos/makefiles/common.mk

BUNDLE_NAME = WAOpenIN
WAOpenIN_FILES = WAOpenIN.mm
WAOpenIN_INSTALL_PATH = /Library/PreferenceBundles
WAOpenIN_FRAMEWORKS = UIKit
WAOpenIN_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/WAOpenIN.plist$(ECHO_END)
