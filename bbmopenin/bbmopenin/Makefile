include theos/makefiles/common.mk

BUNDLE_NAME = BBMOpenIN
BBMOpenIN_FILES = BBMOpenIN.mm
BBMOpenIN_INSTALL_PATH = /Library/PreferenceBundles
BBMOpenIN_FRAMEWORKS = UIKit
BBMOpenIN_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/BBMOpenIN.plist$(ECHO_END)
