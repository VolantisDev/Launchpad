# Update VARIANT in devcontainer.json to pick a Dart version
ARG VARIANT=2
FROM dart:${VARIANT}

# [Option] Install zsh
ARG INSTALL_ZSH="true"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="true"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
ARG USERNAME=vscode
ARG USER_HOME=/home/${USERNAME}
ARG USER_UID=1000
ARG USER_GID=$USER_UID
COPY library-scripts/*.sh /tmp/library-scripts/
RUN apt-get update && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true"

# Add bin location to path
ENV PUB_CACHE="/usr/local/share/pub-cache"
ENV PATH="${PUB_CACHE}/bin:${PATH}"
RUN if ! cat /etc/group | grep -e "^pub-cache:" > /dev/null 2>&1; then groupadd -r pub-cache; fi \
    && usermod -a -G pub-cache ${USERNAME} \
    && umask 0002 \
    && mkdir -p ${PUB_CACHE} \
    && chown :pub-cache ${PUB_CACHE} \
    && sed -i -e "s/export PATH=/export PATH=\/usr\/local\/share\/pub-cache:/" /etc/profile.d/00-restore-env.sh \
    #
    # Fix incorrect privs if present on directories - https://github.com/dart-lang/dart-docker/issues/62, https://github.com/dart-lang/sdk/issues/47093
    && chmod 755 "$DART_SDK" "$DART_SDK/bin"

# Install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    openjdk-11-jdk-headless wget curl git xz-utils zip unzip \
    clang cmake ninja-build pkg-config libgtk-3-dev \
    libwebkit2gtk-4.0-dev libkeybinder-3.0-dev libayatana-appindicator3-dev
# Clean up packages
RUN apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts

# Switch to non-root user
USER ${USERNAME}
WORKDIR ${USER_HOME}

#
# Android SDK
# https://developer.android.com/studio#downloads
# ENV ANDROID_SDK_TOOLS_VERSION=8512546
# ENV ANDROID_PLATFORM_VERSION=33
# ENV ANDROID_BUILD_TOOLS_VERSION=33.0.0
# ENV ANDROID_HOME=~/android-sdk-linux
# ENV ANDROID_SDK_ROOT="$ANDROID_HOME"
# ENV PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/cmdline-tools/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator

# RUN curl -C - --output android-sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip \
# 	&& mkdir -p ${ANDROID_HOME}/ \
# 	&& unzip -q android-sdk-tools.zip -d ${ANDROID_HOME}/cmdline-tools/ \
# 	&& rm android-sdk-tools.zip \
# 	&& yes | sdkmanager --licenses \
# 	&& touch $HOME/.android/repositories.cfg \
# 	&& sdkmanager platform-tools \
# 	&& sdkmanager emulator \
# 	&& sdkmanager "platforms;android-${ANDROID_PLATFORM_VERSION}" "build-tools;$ANDROID_BUILD_TOOLS_VERSION" \
# 	&& sdkmanager --install "cmdline-tools;latest" 
# # create emulator android	
# RUN sdkmanager "system-images;android-${ANDROID_PLATFORM_VERSION};google_apis;x86_64" \
# 	&& avdmanager create avd -n Android${ANDROID_PLATFORM_VERSION} -k "system-images;android-${ANDROID_PLATFORM_VERSION};google_apis;x86_64"

#
# Flutter SDK
# https://flutter.dev/docs/development/tools/sdk/releases?tab=linux
ENV FLUTTER_CHANNEL="stable"
ENV FLUTTER_VERSION="3.3.10"
# Make sure to use the needed channel and version for this.
ENV FLUTTER_HOME=${USER_HOME}/flutter
ENV PATH=${PATH}:${FLUTTER_HOME}/bin

RUN curl -C - --output flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz \
	&& tar -xf flutter.tar.xz -C ~ \
	&& rm flutter.tar.xz \
	&& flutter config --android-sdk "${ANDROID_SDK_ROOT}" \
	&& yes | flutter doctor --android-licenses \
	&& flutter config --no-analytics \
	&& flutter update-packages
