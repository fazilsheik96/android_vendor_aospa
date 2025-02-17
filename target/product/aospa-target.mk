# Copyright (C) 2023 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Enable support for APEX updates
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# b/344511668
PRODUCT_PACKAGES += \
    android.software.credentials.prebuilt.xml

# Enable allowlist for some aosp packages that should not be scanned in a "stopped" state
# Some CTS test case failed after enabling feature config_stopSystemPackagesByDefault
PRODUCT_PACKAGES += initial-package-stopped-states-aosp.xml

# AOSPA Version.
$(call inherit-product, vendor/aospa/target/product/version.mk)

# AOSPA private configuration - optional.
$(call inherit-product-if-exists, vendor/aospa-priv/target/product/aospa-priv-target.mk)

# Aperture
PRODUCT_PACKAGES += \
    Aperture

PRODUCT_PRODUCT_PROPERTIES += \
    persist.vendor.camera.privapp.list=org.lineageos.aperture.dev

# Glimpse
PRODUCT_PACKAGES += \
    Glimpse

# Twelve
PRODUCT_PACKAGES += \
    Twelve

ifeq ($(TARGET_DISABLES_GMS), true)
# Custom Clocks
$(call inherit-product, vendor/SystemUIClocks/product.mk)

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/aospa/prebuilts/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/aospa/prebuilts/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/aospa/prebuilts/bin/50-aospa.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-aospa.sh
ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/aospa/prebuilts/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/aospa/prebuilts/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/aospa/prebuilts/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

# Vanilla apps
PRODUCT_PACKAGES += \
    AvatarPicker \
    Dialer \
    Etar \
    ExactCalculator \
    Jelly \
    LatinIME
endif

# b/189477034: Bypass build time check on uses_libs until vendor fixes all their apps
PRODUCT_BROKEN_VERIFY_USES_LIBRARIES := true

# LMOFreeform
PRODUCT_PACKAGES += \
    LMOFreeform \
    LMOFreeformSidebar

# Camelot
PRODUCT_PACKAGES += \
    Camelot

# DesktopMode
PRODUCT_PACKAGES += \
    DesktopMode

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.freeform_window_management.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.freeform_window_management.xml

$(call inherit-product-if-exists, packages/services/VncFlinger/product.mk)

# OmniJaws
PRODUCT_PACKAGES += \
    OmniJaws \

# GameSpace
PRODUCT_PACKAGES += \
    GameSpace

# APNs
ifneq ($(TARGET_NO_TELEPHONY), true)
PRODUCT_COPY_FILES += \
    vendor/aospa/target/config/apns-conf.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/apns-conf.xml
endif

# Audio
PRODUCT_SYSTEM_PROPERTIES += \
    ro.config.media_vol_steps=30

ifeq ($(TARGET_DISABLES_GMS), true)
# Include AOSP audio files
include vendor/aospa/prebuilts/media/audio/aosp_audio.mk

# Include PA audio files
include vendor/aospa/prebuilts/media/audio/pa_audio.mk

# Default notification/alarm sounds
PRODUCT_PRODUCT_PROPERTIES += \
    ro.config.ringtone=Orion.ogg \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Hassium.ogg
endif

PRODUCT_COPY_FILES += \
    vendor/aospa/prebuilts/misc/Effect_Tick.ogg:$(TARGET_COPY_OUT_PRODUCT)/media/audio/ui/Effect_Tick.ogg

# Boot Animation
$(call inherit-product, vendor/aospa/bootanimation/bootanimation.mk)

# Charger
PRODUCT_PACKAGES += \
    charger_res_images_product_pixel

# curl
PRODUCT_PACKAGES += \
    curl

# Debloater
PRODUCT_PACKAGES += \
    Debloater

# Dex
PRODUCT_DEX_PREOPT_DEFAULT_COMPILER_FILTER := speed

# Dex2oat
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    dalvik.vm.dex2oat64.enabled=true

# Dexpreopt
# Don't dexpreopt prebuilts. (For GMS).
ifneq ($(TARGET_DISABLES_GMS), true)
DONT_DEXPREOPT_PREBUILTS := true
endif

# Optimize everything for preopt
PRODUCT_DEX_PREOPT_DEFAULT_COMPILER_FILTER := everything

# Compile SystemUI on device with `speed`.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.systemuicompilerfilter=speed

PRODUCT_DEXPREOPT_SPEED_APPS += \
    Launcher3QuickStep \
    ParanoidSystemUI

PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.systemuicompilerfilter=speed

# Display
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    debug.sf.frame_rate_multiple_threshold=60 \
    ro.surface_flinger.enable_frame_rate_override=false

# EGL - Blobcache configuration
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.egl.blobcache.multifile=true \
    ro.egl.blobcache.multifile_limit=33554432

# Exfat FS
PRODUCT_PACKAGES += \
    fsck.exfat \
    mkfs.exfat

# Fonts
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,vendor/aospa/fonts/,$(TARGET_COPY_OUT_PRODUCT)/fonts) \
    vendor/aospa/target/config/fonts_customization.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/fonts_customization.xml

# Gestures
PRODUCT_PACKAGES += \
    vendor.aospa.power-service

# Google - GMS, Pixel, and Mainline Modules
ifneq ($(TARGET_DISABLES_GMS), true)
$(warning Building With GMS)
$(call inherit-product, vendor/google/gms/config.mk)
$(call inherit-product, vendor/google/pixel/config.mk)
ifneq ($(TARGET_EXCLUDE_GMODULES), true)
$(call inherit-product-if-exists, vendor/google/modules/build/mainline_modules.mk)
endif
else
$(warning Building Without GMS)
endif

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
     vendor/aospa/target/config/aospa_vendor_framework_compatibility_matrix.xml

PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.manager@1.0 \
    android.hidl.base@1.0.vendor \
    android.hidl.manager@1.0.vendor

# Init
PRODUCT_COPY_FILES += \
    vendor/aospa/prebuilts/etc/init.aospa.rc:$(TARGET_COPY_OUT_SYSTEM)/etc/init/init.aospa.rc

# ART/Dex Debug
ART_BUILD_TARGET_NDEBUG := true
ART_BUILD_TARGET_DEBUG := false
ART_BUILD_HOST_NDEBUG := true
ART_BUILD_HOST_DEBUG := false
WITH_DEXPREOPT_DEBUG_INFO := false
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
USE_DEX2OAT_DEBUG := false

# ART/Dex Debug
ART_BUILD_TARGET_NDEBUG := true
ART_BUILD_TARGET_DEBUG := false
ART_BUILD_HOST_NDEBUG := true
ART_BUILD_HOST_DEBUG := false
WITH_DEXPREOPT_DEBUG_INFO := false
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
PRODUCT_SYSTEM_SERVER_DEBUG_INFO := false
USE_DEX2OAT_DEBUG := false

# Java Optimizations
SYSTEM_OPTIMIZE_JAVA := true
SYSTEMUI_OPTIMIZE_JAVA := true

# MTE
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.arm64.memtag.system_server=off

# Navigation
PRODUCT_PRODUCT_PROPERTIES += \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural

# One Handed Mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# OpenDelta
PRODUCT_PACKAGES += \
    OpenDelta

# Overlays
$(call inherit-product, vendor/aospa/overlay/overlays.mk)

# Overlays (Translations)
$(call inherit-product-if-exists, vendor/aospa/translations/translations.mk)

# Paranoid Packages
PRODUCT_PACKAGES += \
    ParanoidPapers \
    ParanoidSystemUI \
    ParanoidThemePicker

# Paranoid Sense
PRODUCT_PACKAGES += \
    ParanoidSense

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml

# Enable Sense service for 64-bit only
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=$(TARGET_SUPPORTS_64_BIT_APPS)

# Permissions
PRODUCT_COPY_FILES += \
    vendor/aospa/target/config/permissions/default_permissions_com.google.android.deskclock.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/default-permissions/default_permissions_com.google.android.deskclock.xml \
    vendor/aospa/target/config/permissions/privapp-permissions-hotword.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-hotword.xml \
    vendor/aospa/target/config/permissions/privapp-permissions-opendelta.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-opendelta.xml \
    vendor/aospa/target/config/permissions/aospa-power-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/aospa-power-whitelist.xml \
    vendor/aospa/target/config/permissions/org.lineageos.health.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/org.lineageos.health.xml

# Preinstalled Packages
PRODUCT_COPY_FILES += \
    vendor/aospa/target/config/preinstalled-packages-aospa.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/preinstalled-packages-aospa.xml

# Privapp-permissions
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.control_privapp_permissions?=log

# Protobuf - Workaround for prebuilt Qualcomm HAL
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-3.9.1-vendorcompat \
    libprotobuf-cpp-lite-3.9.1-vendorcompat

# QTI VNDK Framework Detect
PRODUCT_PACKAGES += \
    libvndfwk_detect_jni.qti \
    libqti_vndfwk_detect \
    libqti_vndfwk_detect_system \
    libqti_vndfwk_detect_vendor \
    libvndfwk_detect_jni.qti_system \
    libvndfwk_detect_jni.qti_vendor \
    libvndfwk_detect_jni.qti.vendor \
    libqti_vndfwk_detect.vendor

# Qualcomm Common
$(call inherit-product, device/qcom/common/common.mk)

# Rescue Party
# Disable RescueParty due to high risk of data loss
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.disable_rescue=true

# Sensitive Phone Numbers
ifneq ($(TARGET_NO_TELEPHONY), true)
PRODUCT_COPY_FILES += \
    vendor/aospa/target/config/sensitive_pn.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sensitive_pn.xml
endif

# Sensors
PRODUCT_PACKAGES += \
    android.frameworks.sensorservice@1.0.vendor

# StrictMode
ifneq ($(TARGET_BUILD_VARIANT),eng)
# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    persist.sys.strictmode.disable=true
endif

# SEPolicy
$(call inherit-product, vendor/aospa/sepolicy/sepolicy.mk)

# Snapdragon Clang
$(call inherit-product, vendor/qcom/sdclang/config/SnapdragonClang.mk)

# Telephony - CLO
PRODUCT_PACKAGES += \
    extphonelib \
    extphonelib-product \
    extphonelib.xml \
    extphonelib_product.xml \
    ims-ext-common \
    ims_ext_common.xml

ifneq ($(TARGET_NO_TELEPHONY), true)
PRODUCT_PACKAGES += \
    tcmiface \
    telephony-ext \
    qti-telephony-hidl-wrapper \
    qti-telephony-hidl-wrapper-prd \
    qti_telephony_hidl_wrapper.xml \
    qti_telephony_hidl_wrapper_prd.xml \
    qti-telephony-utils \
    qti-telephony-utils-prd \
    qti_telephony_utils.xml \
    qti_telephony_utils_prd.xml

# Telephony - AOSP
PRODUCT_PACKAGES += \
    Stk

PRODUCT_BOOT_JARS += \
    tcmiface \
    telephony-ext
endif

# TextClassifier
PRODUCT_PACKAGES += \
    libtextclassifier_annotator_en_model \
    libtextclassifier_annotator_universal_model \
    libtextclassifier_actions_suggestions_universal_model \
    libtextclassifier_lang_id_model

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/etc/textclassifier/actions_suggestions.universal.model \
    system/etc/textclassifier/lang_id.model \
    system/etc/textclassifier/textclassifier.en.model \
    system/etc/textclassifier/textclassifier.universal.model

# WiFi
PRODUCT_PACKAGES += \
    libwpa_client

PRODUCT_VENDOR_MOVE_ENABLED := true

# Permissions
PRODUCT_COPY_FILES += \
    vendor/aospa/target/config/permissions/privapp-permissions-settings.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-settings.xml
