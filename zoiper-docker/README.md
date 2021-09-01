
build

```
docker build --build-arg USER=$USER --build-arg GID=$(id -g) --build-arg UID=$(id -u) -t zoiper .
```

run

```
docker run -v /tmp/.X11-unix:/tmp/.X11-unix -h $HOSTNAME \
    -v $HOME/.Xauthority:/home/$USER/.Xauthority \
    -v /etc/alsa:/etc/alsa \
    -v /usr/share/alsa:/usr/share/alsa \
    -v $HOME/.config/pulse:$HOME/.config/pulse \
    -v /run/user/$(id -u)/pulse/native:/run/user/$(id -u)/pulse/native \
    -e PULSE_SERVER=unix:/run/user/$(id -u)/pulse/native \
    -e DISPLAY=$DISPLAY \
    --user $(id -u) zoiper
```
