
build

```
docker build --build-arg USER=$USER --build-arg GID=$(id -g) --build-arg UID=$(id -u) -t zoiper .
```

run

```
docker run -v /tmp/.X11-unix:/tmp/.X11-unix \
-h $HOSTNAME -v $HOME/.Xauthority:/home/$USER/.Xauthority \
-e DISPLAY=$DISPLAY zoiper
```
