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

## **Thursday 26/8**
### Creating a Dev Env Using VirtualBox and Vagrant (NginX Web Server)

### INSERT IMAGE

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
(npm is a package manager)
```bash
sudo apt-get install npm -y
```
2. Install `nodejs`
    - Use code in VM:
    ```bash
    sudo apt-get install python-software-properties
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
    sudo apt-get install nodejs -y
    ```
3. Install `pm2` inside `app` directory:
```bash
sudo npm install pm2 -g
```
4. Code: 
```bash
sudo npm install
sudo npm start
```
5. Exit VM then type in
browser `192.163.10.100:3000`


## **Friday 27/8**:
### INSERT IMAGE

*Do first iteration of VM manually, then automate
    - better understanding of system*

#### **Today's Tasks**:
- need VM to provision Mongodb
- need app to connect to db, bring it back and display
- connect to machine through private IP (**198.162.10.150**)
- db port: **27017**
- add instructions through Vagrantfile, then destroy/reload
- **192.168.10.100/posts** --> loads database

<br>

1. Go into VM and enter `app` directory. If machine was restarted, check if VM lost internet connection with:
```bash
 sudo apt-get update -y
```
If error message occurs, then exit the VM and type:
``` bash
vagrant reload
```
or
```bash
vagrant destroy
vagrant up
```

2. Go back to VM and check there's a connection:
```bash
ping www.bbc.com
```
*To manually run the script, type in the terminal:*
```bash
vagrant provision
vagrant status
```

3. Try code again:
```bash
 sudo apt-get update -y
```
4. Install same files from Thursday


### Configure a Reverse Proxy
*want to load node app page on 192.168.10.100 in stead of using :3000*
*use nginx as reverse proxy and redirect to :3000 page*

1. 
```bash
sudo nano /etc/nginx/sites-available/default
```
2. Find `server` block and replace with:
```bash
server {
    listen 80;

    server_name _;

    location / {
        proxy_pass http://localhost:3000;      
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade'; 
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;      
    }
}
```
- COULD ADD ACCESS TO OTHER APPLICATIONS:
```bash
location /*name* {
    proxy_pass http://localhost:*ip*;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
}
```
2. Check for errors:
```bash
sudo nginx -t
```
3. Restart NGINX:
```bash
sudo systemctl restart nginx

sudo npm start
```
4. Automate process by changing `provision.sh` file, adding a new `default.txt` file to replace the NGINX `/etc/nginx/sites-available/default` file and changing the `Vagrantfile`

```bash
# Automating dependencies installation

sudo apt-get install npm -y

sudo apt-get install python-software-properties -y

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -

sudo apt-get install nodejs -y

# Change directories

cd /home/ubuntu/app
sudo npm install pm2 -g -y

npm install

# Change default nginx config file with new default in app_setup/rev_proxy folder

sudo rm /etc/nginx/sites-available/default

sudo ln -s /home/ubuntu/rev_proxy/default.txt /etc/nginx/sites-available/default

sudo nginx -t

sudo systemctl restart nginx
```

<br>

### Creating a Multi Machine Setup

*Machines need to talk to eachother
(api calls, keys, aws, env variables)
in this case we need to create an environment variable (DB_HOST w IP of db)*
- create 2 VM (app and db)
- app provisioned w node, dp w mongodb
- env variable created in app vm called DB_HOST=db-ip:27017/posts
- env can be created w export command in Linux
- check : Printenv DB_HOST
- /posts should load db

1. Create new db directory and create `provision.sh` file
```bash
!#/bin/bash

# Creating provision.sh to run the script

sudo apt-get update -y

sudo apt-get upgrade -y

#Adding MongoDB Repo
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt-get update

#Adding MongoDB Repo
sudo apt-get install -y mongodb-org
sudo systemctl start mongod

#Start MongoDB
sudo systemctl enable mongod
```

2. Add new VM to `Vagrantfile`:
```bash
config.vm.define "db" do |db|
    db.vm.box = "ubuntu/xenial64"
    db.vm.network "private_network", ip: "192.168.10.150"
    db.vm.provision "shell", path: "db_setup/provision.sh"
end
```

3. In directory, change bindIp to 0.0.0.0 :
```bash
sudo nano /etc/mongod.conf
```
4. Automate: add to `Vagrantfile`, `provision.sh` and a new `mongod.conf` file

#### **Linking w NGINX**

1. Create and delete in app VM
```bash
export DB_HOST=mongodb://192.168.10.150:27017/posts

sudo nano cd ~/.bashrc
```

2. exit to Windows then go back in and print env
    - they are NOT persistent
    - need to write them inside `.bashrc` file and execute:
```bash
source ~/.bashrc
```
3. Make it permanent
```bash
export DB_HOST=192.168.10.150:27017/posts
echo "export DB_HOST=192.168.10.150:27017/posts" >> ~/.bashrc
source ~/.bashrc
```
- edit app `provision.sh`
    - add echo and source statement

<br>
IMPORTANT

```bash
echo "DB_HOST=mongodb://192.168.10.150:27017/posts" | sudo tee -a /etc/environment
```


<br>

**Troubleshotting**

- If the npm package isn't working (or anything really), then:
```bash
vagrant destroy
rm -rf .vagrant
vagrant up 
``` 
- To check status of NGINX (see if provisioning file is running):
```bash
systemctl status nginx
```



### To Research:
- reverse proxy

want to create own file and add to provision file

create own mong.con file

change ip adress in file
restart and enable

this is part of process of automation

systemsctl restart systemsctl enable

## **Go to cloud_computing_AWS repository to continue on**
