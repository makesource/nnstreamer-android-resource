#------------------------------------------------------
# tensorflow-lite
#
# This mk file is to build a static library from cloned tensorflow repository.
# To utilize and build a new version, you have to define the root directory and check Makefile to build tensorflow-lite.
# Now this file is to build tensorflow-lite from tizen tensorflow2 repository with version 2.3.0.
#------------------------------------------------------
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := tensorflow-lite

# Need to set tensorflow root dir
ifndef TENSORFLOW_ROOT
$(error TENSORFLOW_ROOT is not defined!)
endif

# Set tensorflow-lite dir (TODO change this with tensorflow-lite version)
TF_LITE_DIR := $(TENSORFLOW_ROOT)/tensorflow/lite
DOWNLOADS_DIR := $(TF_LITE_DIR)/tools/make/downloads

# Set build flags
TF_LITE_FLAGS := -O3 -fPIC -DNDEBUG -DTFLITE_WITH_RUY -DTFLITE_WITHOUT_XNNPACK

# Set files to compile (TODO check Makefile to build tensorflow-lite)
CORE_CC_ALL_SRCS := \
    $(wildcard $(TF_LITE_DIR)/*.cc) \
    $(wildcard $(TF_LITE_DIR)/*.c) \
    $(wildcard $(TF_LITE_DIR)/c/*.c) \
    $(wildcard $(TF_LITE_DIR)/c/*.cc) \
    $(wildcard $(TF_LITE_DIR)/core/*.cc) \
    $(wildcard $(TF_LITE_DIR)/core/api/*.cc) \
    $(wildcard $(TF_LITE_DIR)/experimental/resource/*.cc) \
    $(wildcard $(DOWNLOADS_DIR)/ruy/ruy/*.cc) \
    $(wildcard $(TF_LITE_DIR)/kernels/*.cc) \
    $(wildcard $(TF_LITE_DIR)/kernels/internal/*.cc) \
    $(wildcard $(TF_LITE_DIR)/kernels/internal/optimized/*.cc) \
    $(wildcard $(TF_LITE_DIR)/kernels/internal/reference/*.cc) \
    $(wildcard $(TF_LITE_DIR)/tools/optimize/sparsity/*.cc) \
    $(DOWNLOADS_DIR)/farmhash/src/farmhash.cc \
    $(DOWNLOADS_DIR)/fft2d/fftsg.c \
    $(DOWNLOADS_DIR)/fft2d/fftsg2d.c \
    $(DOWNLOADS_DIR)/flatbuffers/src/util.cpp

CORE_CC_ALL_SRCS += \
    $(shell find $(DOWNLOADS_DIR)/absl/absl/ \
        -type f -name \*.cc | grep -v test | grep -v benchmark | grep -v synchronization | grep -v debugging | grep -v hash | grep -v flags | grep -v random)

# NNAPI
CORE_CC_ALL_SRCS += \
    $(TF_LITE_DIR)/delegates/nnapi/nnapi_delegate.cc \
    $(TF_LITE_DIR)/delegates/nnapi/quant_lstm_sup.cc \
    $(TF_LITE_DIR)/nnapi/nnapi_implementation.cc \
    $(TF_LITE_DIR)/nnapi/nnapi_util.cc

# Remove any duplicates.
CORE_CC_ALL_SRCS := $(sort $(CORE_CC_ALL_SRCS))

CORE_CC_EXCLUDE_SRCS := \
    $(wildcard $(TF_LITE_DIR)/*test.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*test.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/benchmark.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/example*.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/test*.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*test.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*tool.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/benchmark.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/example*.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/test*.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/*test.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/*tool.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/*/benchmark.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/*/example*.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/*/test*.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/*/*test.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/*/*tool.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/*/*/benchmark.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/*/*/example*.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/*/*/test*.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/*/*/*test.cc) \
    $(wildcard $(TF_LITE_DIR)/*/*/*/*/*/*tool.cc) \
    $(wildcard $(TF_LITE_DIR)/kernels/*test_main.cc) \
    $(wildcard $(TF_LITE_DIR)/kernels/*test_util*.cc) \
    $(TF_LITE_DIR)/tflite_with_xnnpack.cc \
    $(TF_LITE_DIR)/examples/minimal/minimal.cc \
    $(TF_LITE_DIR)/mmap_allocation_disabled.cc \
    $(TF_LITE_DIR)/minimal_logging_default.cc \
    $(TF_LITE_DIR)/minimal_logging_ios.cc \
    $(DOWNLOADS_DIR)/ruy/ruy/prepare_packed_matrices.cc

# Filter out all the excluded files.
TF_LITE_CC_SRCS := $(filter-out $(CORE_CC_EXCLUDE_SRCS), $(CORE_CC_ALL_SRCS))
TF_LITE_INCLUDES := \
    $(ANDROID_NDK_ROOT) \
    $(TENSORFLOW_ROOT) \
    $(DOWNLOADS_DIR)/ \
    $(DOWNLOADS_DIR)/eigen \
    $(DOWNLOADS_DIR)/absl \
    $(DOWNLOADS_DIR)/gemmlowp \
    $(DOWNLOADS_DIR)/ruy \
    $(DOWNLOADS_DIR)/neon_2_sse \
    $(DOWNLOADS_DIR)/farmhash/src \
    $(DOWNLOADS_DIR)/flatbuffers/include \
    $(DOWNLOADS_DIR)/fp16/include

LOCAL_ARM_NEON := true
LOCAL_SRC_FILES := $(TF_LITE_CC_SRCS)
LOCAL_C_INCLUDES := $(TF_LITE_INCLUDES)
LOCAL_CFLAGS := $(TF_LITE_FLAGS)
LOCAL_CXXFLAGS := -std=c++11 -frtti -fexceptions $(TF_LITE_FLAGS)

include $(BUILD_STATIC_LIBRARY)
