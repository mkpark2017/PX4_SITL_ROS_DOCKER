# PX4_SITL_ROS_DOCKER

### 1. Build the docker
```
sudo chmod 777 build.sh
source build.sh
```

### 2. Run the docker
```
sudo chmod 777 run.sh
source run.sh
```

### 3. Open VNC viewer with below port (password: password)
```
0.0.0.0:5911
```

### 4. Move into the PX4-Autopilot
```
cd PX4-Autopilot
```

### 5. Run sitl
```
make px4_sitl_default gazebo
```

### 6. Run mavros
```
roslaunch mavros px4.launch fcu_url:="udp://:14540@127.0.0.1:14557" gcs_url:="udp://@172.17.0.1:14550"
```

### 7. Run QGroundControl and add communication link with the port 14550 for UDP

### 8. Arm the motor and change the mode to what ever you want
