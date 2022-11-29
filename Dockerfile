###
# Build the application root fs
###

FROM ubuntu:focal AS build

# From buildx
ARG TARGETPLATFORM

# Install packages
RUN apt-get update
RUN apt-get install -y curl

# Download and unpack SPY Server from AirSpy servers
RUN case "${TARGETPLATFORM}" in \
        linux/amd64)    LINK="https://airspy.com/?ddownload=4262";; \
        linux/arm64)    LINK="https://airspy.com/?ddownload=5795";; \
        linux/arm/v7)   LINK="https://airspy.com/?ddownload=4247";; \
        *)              exit 1;; \
    esac \
 && mkdir -p /buildroot/app /buildroot/config /buildroot/defaults \
 && curl -LsS "${LINK}" | tar -xzf - -C /buildroot/app/

# Configure the entry point
RUN mv /buildroot/app/spyserver.config /buildroot/defaults/
COPY entrypoint.sh /buildroot

###
# Build the final image
###

FROM ubuntu:focal
LABEL maintainer="gizmotronic@gmail.com"

# Install packages
RUN apt-get update \
 && apt-get install -y \
        rtl-sdr \
        librtlsdr-dev

# Copy root filesystem from build stage
COPY --from=build /buildroot /

CMD [ "/entrypoint.sh", "/config/spyserver.config" ]
