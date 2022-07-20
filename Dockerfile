#
# PX4 ROS development environment
#

FROM nvcr.io/nvidia/l4t-base:r32.4.3
LABEL maintainer="Minkyu Park <mk.park@unist.ac.kr>"


ENV ROS_DISTRO melodic
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
          git \
		cmake \
		build-essential \
		curl \
		wget \
		gnupg2 \
		lsb-release \
		ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# setup ros keys
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN apt-get update
RUN apt-get -y --quiet --no-install-recommends install \
		geographiclib-tools \
		libeigen3-dev \
		libgeographic-dev \
		libopencv-dev \
		libyaml-cpp-dev \
		python-pip \
		python-tk \
		ros-$ROS_DISTRO-gazebo-ros-pkgs \
		ros-$ROS_DISTRO-mav-msgs


RUN apt-get -y install ros-$ROS_DISTRO-mavlink \
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


RUN pip install wheel setuptools

RUN echo "# enable bash completion in interactive shells \n\
if ! shopt -oq posix; then \n\
  if [ -f /usr/share/bash-completion/bash_completion ]; then \n\
    . /usr/share/bash-completion/bash_completion \n\
  elif [ -f /etc/bash_completion ]; then \n\
    . /etc/bash_completion \n\
  fi \n\
fi" >> ~/.bashrc
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

RUN echo '# convert USB port name \n\
SUBSYSTEM=="tty", ATTRS{idVendor}=="067b", ATTRS{idProduct}=="2303", MODE="0666", SYMLINK+="ttyPX4" \n\
SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", MODE="0666", SYMLINK+="ttyBLE" \n\
' >> /etc/udev/rules.d/50-usb-serial.rules
COPY udev /etc/init.d/udev

WORKDIR /root
#RUN git clone https://github.com/mkpark2017/PX4-Autopilot.git

# bootstrap rosdep
RUN pip install rosdep
RUN rosdep init && rosdep update

RUN apt-get update && \
    apt-get install -y net-tools \
    nano \
    x11-apps \
    x11vnc \
    xvfb \
    fluxbox \
    wmctrl \
    xterm && \
    apt-get clean


RUN rm /etc/apt/apt.conf.d/docker-clean
RUN apt update -y

EXPOSE 5900

COPY startup.sh /.
RUN chmod 777 /startup.sh
ENTRYPOINT /startup.sh --allow-root && /bin/bash
