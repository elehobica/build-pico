#------------------------------------------------------
# Copyright (c) 2025, Elehobica
# Released under the BSD-2-Clause
# refer to https://opensource.org/licenses/BSD-2-Clause
#------------------------------------------------------

FROM elehobica/pico-sdk-dev-docker:sdk-2.1.1-1.0.0

RUN mkdir -p /home/rp2dev/work
COPY build-pico.sh /home/rp2dev/work/
USER root
RUN chmod +x /home/rp2dev/work/build-pico.sh
ENTRYPOINT ["/home/rp2dev/work/build-pico.sh"]
