FROM mcr.microsoft.com/playwright:v1.45.1-jammy

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV PUPPETEER_EXECUTABLE_PATH=/ms-playwright/chromium-1124/chrome-linux/chrome

WORKDIR /usr/app

# Install necessary packages
RUN apt-get update && apt-get install -y \
    dbus-x11 \
    upower \
    xvfb \
    ffmpeg \
    xauth \
    axios

# Install puppeteer so it's available in the container.
RUN npm i puppeteer-core

ENV PUPPETEER_SKIP_DOWNLOAD true
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true
ENV DBUS_SESSION_BUS_ADDRESS autolaunch:
# ENV PUPPETEER_CACHE_DIR 

ENV DISPLAY :0
ENV XAUTHORITY=/root/.Xauthority

# Expose the port
EXPOSE 8080

ADD run.sh /usr/app/run.sh
RUN chmod a+x /usr/app/run.sh

# Set up a default command
ENTRYPOINT [ "./run.sh" ]