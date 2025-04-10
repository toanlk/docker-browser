# SeleniumBase Docker Image
FROM ubuntu:22.04
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=UTF-8

#======================
# Locale Configuration
#======================
RUN apt-get update
RUN apt-get install -y --no-install-recommends tzdata locales
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8

#======================
# Install Common Fonts
#======================
RUN apt-get update
RUN apt-get install -y \
    fonts-liberation \
    fonts-liberation2 \
    fonts-font-awesome \
    fonts-ubuntu \
    fonts-terminus \
    fonts-powerline \
    fonts-open-sans \
    fonts-mononoki \
    fonts-roboto \
    fonts-lato

#============================
# Install Linux Dependencies
#============================
RUN apt-get update
RUN apt-get install -y \
    supervisor \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libu2f-udev \
    libvulkan1 \
    libwayland-client0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    libegl-dev \
    libpci-dev \
    # install a lightweight window manager
    fluxbox \
    eterm \
    # install pip
    python3-pip \
    # install xvfb/pyvirtualdisplay packages
    xvfb \
    xserver-xephyr \
    xauth \
    tigervnc-standalone-server \
    x11-utils \
    gnumeric \
    net-tools \
    dbus-x11 \
    libgl1-mesa-dri \
    mesa-utils \
    alsa-utils \
    # install vnc server for remote access
    x11vnc \
    # tkinter is necessary to get the mouse position with pyautogui
    python3-dev \
    python3-tk \
    # necessary to take screenshots with pyautogui
    scrot \
    gnome-screenshot \
    # gui
    xfce4 \
    xfce4-terminal \
    xterm \
    libdbus-glib-1-2 \
    xfonts-100dpi \
    xfonts-75dpi \
    tigervnc-common \
    tigervnc-standalone-server

#==========================
# Install useful utilities
#==========================
RUN apt-get update
RUN apt-get install -y xdg-utils ca-certificates

#=================================
# Install Bash Command Line Tools
#=================================
RUN apt-get update
RUN apt-get -qy --no-install-recommends install \
    curl \
    sudo \
    unzip \
    vim \
    wget \
    xvfb

#================
# Install Chrome
#================
RUN apt-get update
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install -y ./google-chrome-stable_current_amd64.deb
RUN rm ./google-chrome-stable_current_amd64.deb

#================
# Install Python
#================
RUN apt-get update
RUN apt-get install -y python3 python3-pip python3-setuptools python3-dev python3-tk
RUN alias python=python3
RUN echo "alias python=python3" >> ~/.bashrc
RUN apt-get -qy --no-install-recommends install python3.10
RUN rm /usr/bin/python3
RUN ln -s python3.10 /usr/bin/python3

#===============
# Cleanup Lists
#===============
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

#=====================
# Set up SeleniumBase
#=====================
RUN pip install --upgrade pip setuptools wheel
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

#=======================
# Download chromedriver
#=======================
RUN seleniumbase get chromedriver --path