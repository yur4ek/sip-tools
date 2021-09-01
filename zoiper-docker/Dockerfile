FROM debian
ARG USER
ARG UID
ARG GID
ENV USER=${USER}
ENV UID=${UID}
ENV GID=${GID}

RUN groupadd -g $GID $USER
RUN useradd -d /home/$USER -s /bin/bash -m $USER -u $UID -g $GID

RUN apt-get update
RUN apt-get -y install apt-utils libpulse0 libgtk2.0-0 libdrm2 libgbm1 libasound2 libnotify4 libv4l-0 libnss3 libxkbcommon0 libxss1 libasound2-plugins
ADD Zoiper5_5.5.3_x86_64.deb /root
RUN dpkg -i /root/Zoiper5_5.5.3_x86_64.deb

USER $USER
ENV HOME=/home/$USER
CMD /usr/bin/zoiper5
