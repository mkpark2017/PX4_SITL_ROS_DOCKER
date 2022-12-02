#!/bin/bash
nvidia-docker run -it \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --volume="/dev:/dev" \
    --device=/dev/nvidiactl \
    --device=/dev/nvidia-uvm \
    --device=/dev/nvidia0 \
    --name px4_gazebo \
    --privileged \
    --net=host \
    mk/px4_gazebo
