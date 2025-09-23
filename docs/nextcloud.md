# Nextcloud Setup

This guide documents how to install Nextcloud inside the Ubuntu Server VM.

---

## Update system

```bash
sudo apt update && sudo apt upgrade -y
```

## Install Nextcloud dependencies

```bash
sudo apt install apache2 mariadb-server libapache2-mod-php -y
sudo apt install php php-gd php-json php-mysql php-curl php-mbstring php-intl php-xml php-zip php-bz2 php-bcmath -y
```
- This install the dependencies like Apache, MariaDB, and all the php modules that Nextcloud needs.

## Run secure MariaDB (Optional)
- A guided installation script to make your database safer. (Built-in script) See './scripts/secure-install.sh'
- Used to set a root password, remove anonymous user, remove test database, etc.

## Log into MariaDB and create a database and user

```bash
sudo mysql -u root -p
```
- To create database and user see './examples/database.sql'

## Download Nextcloud

```bash
cd /tmp
wget https://download.nextcloud.com/server/releases/latest-30.tar.bz2
tar -xjf latest.tar.bz2
sudo mv nextcloud /var/www/
```

## Set Permission

```bash
sudo chown -R www-data:www-data /var/www/html/nextcloud
sudo chmod -R 755 /var/www/html/nextcloud
```

## Configure Apache

- Create /etc/apache2/sites-avilable/nextcloud.conf
- Configure your port, localdomain and grant access to nextcloud directory. See './examples/nextcloud-setup.conf
- Enable modules and sites

```bash
sudo a2ensite nextcloud.conf
sudo a2enmod rewrite headers env dir mime
sudo systemctl restart apache2
```

## Finish Setup

- In your browser (or mobile device connected with WireGuard) open

```bash
http://10.10.0.1:8080
```
- You will see the NextCloud setup page.

![nextcloud-setup](https://raw.githubusercontent.com/Sharethefile/Ubuntu-virtualbox-lab/main/screenshots/nexcloud-login.png)

- Fill the details
    - Create a admin user
    - Add password
    - Database user: (Eg: user)
    - Database password: (Eg: password)
    - Database name: (Eg: nextcloud)

- Click install
- You will see the dashboard once installed

![nextcloud-dashboard](https://raw.githubusercontent.com/Sharethefile/Ubuntu-virtualbox-lab/main/screenshots/nextcloud-dashboard.png)