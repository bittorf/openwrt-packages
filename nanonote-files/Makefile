include $(TOPDIR)/rules.mk

PKG_NAME:=nanonote-files
PKG_VERSION:=201204

include $(INCLUDE_DIR)/package.mk

define Package/nanonote-files/Default
    MAINTAINER:="Xiangfu Liu" <xiangfu@sharism.cc>
    TITLE:=NanoNote Files
    SECTION:=utils
    CATEGORY:=Utilities
endef

define Package/nanonote-example-files
    $(call Package/nanonote-files/Default)
    TITLE+=(Example Files)
endef

define Package/nanonote-base-files
    $(call Package/nanonote-files/Default)
    TITLE+=(Base Files)
endef

define Package/nanonote-data-files
    $(call Package/nanonote-files/Default)
    TITLE+=(Date Files)
endef

define Package/nanonote-gmenu2x-icons
    $(call Package/nanonote-files/Default)
    TITLE+=(Gmenu2x Icons)
endef

define Build/Compile
endef

define Package/nanonote-example-files/install
	$(CP) ./example-files/* $(1)/
endef

define Package/nanonote-base-files/install
	$(CP) ./base-files/* $(1)/
endef

define Package/nanonote-data-files/install
	$(INSTALL_DIR) $(1)/usr/share/nanonote/
	$(INSTALL_DIR) $(1)/usr/share/nanonote/files/

	$(CP) ./files/* $(1)/usr/share/nanonote/files/
	$(CP) ./data/qi_lb60/* $(1)/usr/share/nanonote/
endef

define Package/nanonote-data-files/postinst
#! /bin/sh
cp -af $${IPKG_INSTROOT}/usr/share/nanonote/files/* $${IPKG_INSTROOT}/
endef

define Package/nanonote-gmenu2x-icons/install
	$(INSTALL_DIR) $(1)/usr/share/gmenu2x
	$(CP) gmenu2x-icons/gmenu2x/* $(1)/usr/share/gmenu2x/
endef

$(eval $(call BuildPackage,nanonote-example-files))
$(eval $(call BuildPackage,nanonote-base-files))
$(eval $(call BuildPackage,nanonote-data-files))
$(eval $(call BuildPackage,nanonote-gmenu2x-icons))
