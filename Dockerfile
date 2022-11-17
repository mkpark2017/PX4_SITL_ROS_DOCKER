#
# PX4 ROS development environment
#

FROM px4io/px4-dev-simulation-bionic:2021-09-08
LABEL maintainer="Minkyu Park <mk.park@unist.ac.kr>"


ENV ROS_DISTRO melodic

# setup ros keys
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list' \
	&& sh -c 'echo "deb http://packages.ros.org/ros-shadow-fixed/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-shadow.list' \
	&& apt-get update \
	&& apt-get -y --quiet --no-install-recommends install \
		bash-completion \
		geographiclib-tools \
		nvidia-driver-470 \
		libeigen3-dev \
		libgeographic-dev \
		libopencv-dev \
		libyaml-cpp-dev \
		python-pip \
		python-tk \
		ros-$ROS_DISTRO-gazebo-ros-pkgs \
		ros-$ROS_DISTRO-mav-msgs \
		ros-$ROS_DISTRO-mavlink \
		ros-$ROS_DISTRO-mavros \
		ros-$ROS_DISTRO-mavros-extras \
		ros-$ROS_DISTRO-octomap \
		ros-$ROS_DISTRO-octomap-msgs \
		ros-$ROS_DISTRO-pcl-conversions \
		ros-$ROS_DISTRO-pcl-msgs \
		ros-$ROS_DISTRO-pcl-ros \
		ros-$ROS_DISTRO-ros-base \
		ros-$ROS_DISTRO-rostest \
		ros-$ROS_DISTRO-rosunit \
		ros-$ROS_DISTRO-xacro \
		xvfb \
	&& geographiclib-get-geoids egm96-5 \
	&& apt-get -y autoremove \
	&& apt-get clean autoclean \
	&& rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# Install everything again for Python 2 because we could not get Firmware
# to compile using catkin without it.
RUN pip install wheel setuptools
# FIXME: regression in control>0.8.4 (used by px4tools) does not run on Python 2.
RUN pip install argcomplete argparse catkin_pkg catkin-tools cerberus coverage \
    empy jinja2 matplotlib==2.2.* numpy pkgconfig control==0.8.4 px4tools pygments \
    pymavlink packaging pyros-genmsg pyulog==0.8.0 pyyaml requests rosdep rospkg \
    serial six toml jsonschema==2.6.0

RUN echo "# enable bash completion in interactive shells \n\
if ! shopt -oq posix; then \n\
  if [ -f /usr/share/bash-completion/bash_completion ]; then \n\
    . /usr/share/bash-completion/bash_completion \n\
  elif [ -f /etc/bash_completion ]; then \n\
    . /etc/bash_completion \n\
  fi \n\
fi" >> ~/.bashrc


RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

WORKDIR /root
RUN git clone https://github.com/mkpark2017/PX4-Autopilot.git

# bootstrap rosdep
RUN rosdep init && rosdep update

RUN apt-get update && \
    apt-get install -y net-tools \
    nano \
    x11-apps \
    xvfb \
    fluxbox \
    wmctrl \
    xterm && \
    apt-get clean

RUN rm /etc/apt/apt.conf.d/docker-clean
RUN apt update -y

EXPOSE 5900
