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

echo "Downloading TOCABI packages..."



wget --no-check-certificate \
https://drive.google.com/drive/u/3/home \
-O dyros_tocabi_v2.zip

echo "Extracting TOCABI packages..."

unzip dyros_tocabi_v2.zip
