#!/bin/bash
set -e

echo "================================="
echo "TOCABI + ISAACLAB AUTO INSTALLER"
echo "================================="

########################################
# 1 Install system dependencies
########################################
echo "Installing system dependencies..."

sudo apt update

sudo apt install -y \
    build-essential \
    cmake \
    git \
    wget \
    curl \
    unzip \
    python3-pip \
    python3-dev \
    lsb-release

########################################
# 2 Install Miniconda
########################################

echo "Installing Miniconda..."

cd ~

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda

source "$HOME/miniconda/etc/profile.d/conda.sh"

conda init

########################################
# 3 Create IsaacLab environment
########################################

echo "Creating conda environment..."

conda create -y -n env_isaaclab python=3.11
conda activate env_isaaclab

########################################
# 4 Install PyTorch
########################################

echo "Installing PyTorch..."

pip install torch==2.7.0 torchvision==0.22.0 \
--index-url https://download.pytorch.org/whl/cu128

########################################
# 5 Install IsaacSim
########################################

echo "Installing IsaacSim..."

pip install --upgrade pip

pip install "isaacsim[all,extscache]==5.1.0" \
--extra-index-url https://pypi.nvidia.com

########################################
# 6 Clone IsaacLab
########################################

echo "Cloning IsaacLab..."

cd ~

git clone https://github.com/isaac-sim/IsaacLab.git

cd IsaacLab

########################################
# 7 Install IsaacLab
########################################

echo "Installing IsaacLab frameworks..."

./isaaclab.sh --install

########################################
# 8 Verify installation
########################################

echo "Running test simulation..."

./isaaclab.sh -p scripts/tutorials/00_sim/create_empty.py

echo "================================="
echo "ISAACLAB INSTALL COMPLETE"
echo "================================="

########################################
# 9 Install ROS Noetic
########################################

echo "Installing ROS Noetic..."

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

sudo apt update

sudo apt install -y ros-noetic-desktop-full

########################################
# 10 Setup ROS environment
########################################

echo "Setting up ROS environment..."

echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

source /opt/ros/noetic/setup.bash

########################################
# 11 Install ROS build tools
########################################

sudo apt install -y \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    python3-catkin-tools

sudo rosdep init || true
rosdep update


########################################
# 14 Adding Eigen, RBDL, qpOASES
########################################

sudo apt install -y \
    libeigen3-dev \
    libyaml-cpp-dev \
    libboost-all-dev

    ########################################
# Install RBDL
########################################

echo "Installing RBDL..."

cd ~

git clone https://github.com/rbdl/rbdl.git

cd rbdl

mkdir build
cd build

cmake ..

make -j$(nproc)

sudo make install

########################################
# Install qpOASES
########################################

echo "Installing qpOASES..."

cd ~

git clone https://github.com/coin-or/qpOASES.git

cd qpOASES

mkdir build
cd build

cmake ..

make -j$(nproc)

sudo make install

########################################
# 11 Install TOCABI
########################################

echo "Downloading TOCABI packages..."

wget --no-check-certificate "https://drive.google.com/uc?export=download&id=1yNfBKNSicUEOmNNVmM9JLR-eMDfcHoqH" -O dyros_tocabi_v2.zip
pip install gdown
gdown 1yNfBKNSicUEOmNNVmM9JLR-eMDfcHoqH
unzip dyros_tocabi_v2.zip

echo "Extracting TOCABI packages..."

unzip dyros_tocabi_v2.zip

########################################
# 14 Create ROS workspace
########################################

echo "Creating TOCABI workspace..."

mkdir -p ~/tocabi_ws/src

cd ~/tocabi_ws

catkin_make

echo "source ~/tocabi_ws/devel/setup.bash" >> ~/.bashrc
