include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KakaoTalkTools
KakaoTalkTools_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk


SUBPROJECTS += Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
