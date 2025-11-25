FROM mcr.microsoft.com/playwright:v1.56.1-jammy

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV PUPPETEER_EXECUTABLE_PATH=/ms-playwright/chromium-1194/chrome-linux/chrome

WORKDIR /usr/app

# Install necessary packages
RUN apt-get update && apt-get install -y \
    dbus-x11 \
    upower \
    xvfb \
    ffmpeg \
    xauth \
    curl \
    ca-certificates \
    build-essential \
    python3
ARG ABP_VERSION=4.31.1

# Download and prepare Adblock Plus
RUN mkdir -p /usr/app/extensions/abp && \
    curl -L "https://gitlab.com/eyeo/browser-extensions-and-premium/extensions/extensions/-/archive/adblockplus-${ABP_VERSION}/extensions-adblockplus-${ABP_VERSION}.tar.gz" \
      -o /tmp/abp.tar.gz && \
    tar -xzf /tmp/abp.tar.gz -C /tmp && \
    cd /tmp/extensions-adblockplus-${ABP_VERSION} && \
    npm install && \
    npm run build && \
    cd host/adblockplus && \
    npm run build -- chrome 3 && \
    cp -r dist/devenv/chrome-mv3/* /usr/app/extensions/abp && \
    rm -rf /tmp/abp.tar.gz /tmp/extensions-adblockplus-${ABP_VERSION}

# Install axios and form-data for Slack notifications.
RUN npm i axios form-data

# Install puppeteer so it's available in the container.
RUN npm i puppeteer-core

ENV PUPPETEER_SKIP_DOWNLOAD true
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV DBUS_SESSION_BUS_ADDRESS autolaunch:

ENV DISPLAY :0
ENV XAUTHORITY=/root/.Xauthority

EXPOSE 8080

ADD run.sh /usr/app/run.sh
RUN chmod a+x /usr/app/run.sh

ENTRYPOINT [ "./run.sh" ]
