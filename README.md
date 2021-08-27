# SRE introduction
## Cloud computing w AWS
### SDLC stages
#### Risk factors with SDLC stages
##### Monitoring

### Key Advantages
- Ease of use
- Flexibility
- Robustness
- Cost

**SRE Introduction**
- What is the role of SRE?

-- Building and implemting change to a server


**Cloud Computing**
- What is Cloud Computing and the benefits of using it?

-- On demand resources (storage, power, location
-- Cloud Computing provides a wide range of technolgies that the user can access on a as-need basis
-- Rapid
-- Scalability
-- Saves cost


**Amazon Web Services (AWS)**
- What is AWS and the benefits of using it?

-- Cloud platform
-- Secure
-- Global reach

**SDLC and Stages of SDLC**
![image](https://www.goodfirms.co/glossary/wp-content/uploads/2017/07/Software-Development-Life-Cycle.png)
- What is SDLC and what are the stages of it?

-- Methodology of creating software
-- Different phases of software development
Requirement analysis
Planning
Software design such as architectural design
Software development
Testing
Deployment

**SDLC Risk levels**
- What are the risk level at each stage of SDLC?
- Low: Requirement Analysis
- Medium: Planning/Design, Testing
- High: Development/Implementation, Deployment&Maintenance


### Creating a Dev Env Using VirtualBox and Vagrant (NginX Web Server)

1. Create file `Vagrantfile` -- (vim Vagrantfile)
    - Add code: 
    ```bash 
    Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/xenial64"
    config.vm.network "private_network", ip: "192.168.10.100"
    end
    ```
2. Run `vagrant up` in terminal (make sure it's in same directory as `Vagrantfile`)
3. Type (in succession):
```bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install nginx -y
```
- -y automatically inputs `yes`
4. Check if nginx package was installed:
```bash
systemctl status nginx
```
5. Type in `192.163.10.100` in web browser
6. Create a `provision.sh` file in same directory as `Vagrantfile` -- use git bash:
```bash
!#/bin/bash

# Let's automate the installation of nginx

sudo apt-get update -y

sudo apt-get upgrade -y

sudo apt-get install nginx -y

# Creating provision.sh to run the script
```
7. Make executable:
```bash
sudo chmod +x provision.sh
```
8. Place `provision.sh` with `Vagrantfile`
    - Run `vagrant destroy` in same directory, the run `rm -rf .vagrant`
    - Update `Vagrantfile`:
    ```bash
    # Provisioning
    config.vm.provision "shell", path: "provision.sh", privileged: false
    ```
9. Run: `vagrant up` to start up VM
10. Add to `Vagrantfile`:
```bash
# Synced app folder - path of your host machine
    config.vm.synced_folder "app", "/home/ubuntu/app"
```
### Installing Dependancies for App

1. Within **vagrant**, install `npm`:
```bash
sudo apt-get install npm -y
```
    - npm is a package manager
2. Install `nodejs`
    - Use code in VM:
    ```bash
    sudo apt-get install python-software-properties
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
    sudo apt-get install nodejs -y
    ```
3. Install `pm2` inside `app` directory:
```bash
sudo npm insatll pm2 -g
```
4. Code: 
```bash
sudo npm install
sudo npm start
```
5. Exit VM then type in
browser `192.163.10.100:3000`

### To Research:
- reverse proxy
