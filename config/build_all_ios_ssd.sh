#!/usr/bin/env bash
# Copyright 2015 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================

set -e

# Make sure we're on OS X.
if [[ $(uname) != "Darwin" ]]; then
    echo "ERROR: This makefile build requires OS X, which the current system "\
    "is not."
    exit 1
fi

# Make sure we're in the correct directory, at the root of the source tree.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd ${SCRIPT_DIR}/../../../


# Remove any old files first.
make -f tensorflow/contrib/makefile/Makefile_ios clean
rm -rf tensorflow/contrib/makefile/downloads

# Setting a deployment target is required for building with bitcode,
# otherwise linking will fail with:
#
#    ld: -bind_at_load and -bitcode_bundle (Xcode setting ENABLE_BITCODE=YES) cannot be used together
#
export MACOSX_DEPLOYMENT_TARGET="10.10"

# Pull down the required versions of the frameworks we need.
tensorflow/contrib/makefile/download_dependencies.sh

# Compile protobuf for the target iOS device architectures.
tensorflow/contrib/makefile/compile_ios_protobuf.sh

# Build the iOS TensorFlow libraries.
tensorflow/contrib/makefile/compile_ios_tensorflow_s.sh "-O3 -DANDROID_TYPES=ANDROID_TYPES_FULL -DSELECTIVE_REGISTRATION -DSUPPORT_SELECTIVE_REGISTRATION" 

# Creates a static universal library in 
# tensorflow/contrib/makefile/gen/lib/libtensorflow-core.a

