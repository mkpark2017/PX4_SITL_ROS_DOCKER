# PX4_SITL_ROS_DOCKER

### 1. Build the docker
* Edit nvidia-driver version to match your GPU and driver (e.g., 470 -> 530)
```
sudo chmod 777 build.sh
source build.sh
```

### 2. Run the docker
```
sudo chmod 777 run.sh
source run.sh
```

### 3. Make X-server can access to X-host (run the command in host terminal)
```
xhost +
```

### 4. Move into the PX4-Autopilot (in docker)
```
cd PX4-Autopilot
```

### 5-1. Run sitl (Single UAV)
```
make px4_sitl_default gazebo
```

### 5-2. (Optional) Run muti-uav sitl and mavros (mult-UAVs)
*(ref. https://docs.px4.io/v1.12/en/simulation/multi_vehicle_simulation_gazebo.html)
```
DONT_RUN=1 make px4_sitl_default gazebo
```


### 6-1. Run mavros (Single UAV)
```
roslaunch mavros px4.launch fcu_url:="udp://:14540@127.0.0.1:14557" gcs_url:="udp://@172.17.0.1:14550"
```


### 6-1. (Optional) Run mavros (multi-UAVs)
```
source Tools/setup_gazebo.bash $(pwd) $(pwd)/build/px4_sitl_default
export ROS_PACKAGE_PATH=$ROS_PACKAGE_PATH:$(pwd):$(pwd)/Tools/sitl_gazebo
roslaunch px4 multi_uav_mavros_sitl.launch
```



### 7. Run QGroundControl
* add communication link with the port 14550 for UDP
* arm the motor and change the mode to what ever you want
