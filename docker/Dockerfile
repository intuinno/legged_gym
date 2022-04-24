FROM nvcr.io/nvidia/pytorch:22.03-py3
ENV DEBIAN_FRONTEND=noninteractive 

# dependencies for gym
#
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
 libxcursor-dev \
 libxrandr-dev \
 libxinerama-dev \
 libxi-dev \
 mesa-common-dev \
 zip \
 unzip \
 make \
 gcc-8 \
 g++-8 \
 vulkan-utils \
 mesa-vulkan-drivers \
 pigz \
 git \
 libegl1 \
 git-lfs \
 zsh \ 
 sudo 

# Force gcc 8 to avoid CUDA 10 build issues on newer base OS
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 8
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 8

# WAR for eglReleaseThread shutdown crash in libEGL_mesa.so.0 (ensure it's never detected/loaded)
# Can't remove package libegl-mesa0 directly (because of libegl1 which we need)
RUN rm /usr/lib/x86_64-linux-gnu/libEGL_mesa.so.0 /usr/lib/x86_64-linux-gnu/libEGL_mesa.so.0.0.0 /usr/share/glvnd/egl_vendor.d/50_mesa.json

COPY docker/nvidia_icd.json /usr/share/vulkan/icd.d/nvidia_icd.json
COPY docker/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json


#RUN useradd --create-home gymuser
#USER gymuser
RUN addgroup --gid 1001 intuinno
RUN adduser --disabled-password --gecos '' --uid 1001 --gid 1001 intuinno
RUN adduser intuinno sudo 

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> \
/etc/sudoers 

USER intuinno


WORKDIR /opt/isaacgym 
COPY --chown=intuinno ./isaacgym . 


 # install gym modules
ENV PATH="/home/intuinno/.local/bin:$PATH"

ENV NVIDIA_VISIBLE_DEVICES=all NVIDIA_DRIVER_CAPABILITIES=all

# install gym env
WORKDIR /opt/isaacgym/python 
RUN pip install -q -e . 

WORKDIR /home/intuinno
