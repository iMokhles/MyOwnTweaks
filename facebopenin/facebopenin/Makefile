include theos/makefiles/common.mk

BUNDLE_NAME = FaceBOpenIN
FaceBOpenIN_FILES = FaceBOpenIN.mm
FaceBOpenIN_INSTALL_PATH = /Library/PreferenceBundles
FaceBOpenIN_FRAMEWORKS = UIKit
FaceBOpenIN_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/FaceBOpenIN.plist$(ECHO_END)
