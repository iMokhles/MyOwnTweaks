include theos/makefiles/common.mk

BUNDLE_NAME = InstaCopyTXT
InstaCopyTXT_FILES = InstaCopyTXT.mm
InstaCopyTXT_INSTALL_PATH = /Library/PreferenceBundles
InstaCopyTXT_FRAMEWORKS = UIKit
InstaCopyTXT_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/InstaCopyTXT.plist$(ECHO_END)
