include theos/makefiles/common.mk

BUNDLE_NAME = FBCopyTXT
FBCopyTXT_FILES = FBCopyTXT.mm
FBCopyTXT_INSTALL_PATH = /Library/PreferenceBundles
FBCopyTXT_FRAMEWORKS = UIKit
FBCopyTXT_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FBCopyTXT.plist$(ECHO_END)
