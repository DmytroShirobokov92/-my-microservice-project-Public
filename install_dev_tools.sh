#!/bin/bash

echo "= Start script with comand 'set -e' ="

set -e

echo "= Check if/and install Python =" 

if ! command -v python3 &>/dev/null; then
    echo "Python is not installed. Installing python or python3..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get update
        sudo apt-get install -y python3 python3-pip
    elif command -v yum &>/dev/null; then
        sudo yum install -y python3 python3-pip
    else
        echo "Unsupported package manager. Please install Python manually."
        exit 1
    fi
else
    echo "Python is already installed: $(python3 --version)"
    python_version=$(python3 -V | awk '{print $2}')
    major=$(echo $python_version | cut -d. -f1)
    minor=$(echo $python_version | cut -d. -f2)
    if [ "$major" -lt 3 ] || { [ "$major" -eq 3 ] && [ "$minor" -lt 9 ]; }; then
        echo "Python version is less than 3.9. Please update Python to version 3.9 or higher."
        exit 1
    else
        echo "Python version >=3.9"
    fi
fi



echo "= Check if/and Install pip ="

if ! command -v pip3 &>/dev/null; then
    echo "pip is not installed. Installing pip..."
    if command -v apt-get &>/dev/null; then
        if ! sudo apt-get install -y python3-pip; then
            echo "apt-get failed. try get-pip..."
            curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py
            python3 get-pip.py --break-system-packages
            rm get-pip.py
        fi
    elif command -v yum &>/dev/null; then
        if ! sudo yum install -y python3-pip; then
            echo "yum failed. try get-pip..."
            curl -sS https://bootstrap.pypa.io/get-pip.py -o get-pip.py
            python3 get-pip.py --break-system-packages
            rm get-pip.py
        fi        
    else
        echo "Unsupported package manager. Please install pip manually."
        exit 1
    fi
else
    echo "pip is already installed: $(pip3 --version)"
fi



echo "= Check if/and venv installed ="
if ! python3 -m venv --help &>/dev/null; then
    echo "venv module is not installed. Installing python3-venv..."
    if command -v apt-get &>/dev/null; then
        sudo apt-get update
        sudo apt-get install -y python3-venv 
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y python3-venv
    elif command -v yum &>/dev/null; then
        sudo yum install -y python3-venv 
    else
        echo "Unsupported package manager. Please install python3-venv manually."
        exit 1
    fi
else
    echo "Venv is already available in Python"
fi



echo "Check if/and Django installed"

if [ ! -d "django_venv" ]; then
    echo "Now we create Environment for Django named django_venv..."
    python3 -m venv django_venv
fi

source django_venv/bin/activate

if ! python3 -c "import django" &>/dev/null; then
    echo "Django is not installed inside django_venv -> Installing Django inside django_venv..."
    pip install Django    
else
    echo "Django is already installed use django_venv environment: $(python3 -m django --version)"
fi

deactivate



echo "= Check if/and Docker Installed ="

if ! command -v docker &>/dev/null; then
    if command -v apt-get &>/dev/null; then
        sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
        | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update -y
        sudo apt install -y docker-ce docker-ce-cli containerd.io
        sudo usermod -aG docker $USER
    elif command -v yum &>/dev/null; then
        sudo yum install -y yum-utils
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        sudo yum install -y docker-ce docker-ce-cli containerd.io
        sudo systemctl enable docker
        sudo systemctl start docker
        sudo usermod -aG docker $USER
    elif command -v dnf &>/dev/null; then
        sudo dnf -y install dnf-plugins-core
        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
        sudo dnf install -y docker-ce docker-ce-cli containerd.io
        sudo systemctl enable docker
        sudo systemctl start docker
        sudo usermod -aG docker $USER
    else 
        echo "Unsupported package manager. Please install Docker manually."
        exit 1
    fi
else
    echo "Docker is already installed: $(docker --version)"
fi



echo "= Check if/and Docker-Compose installed ="

if ! command -v docker-compose &>/dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
else
    echo "Docker Compose is already installed: $(docker-compose --version)"
fi


echo "= Your tools INSTALLED! ="
