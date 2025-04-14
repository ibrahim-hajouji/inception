
* This project is part of the 42 curriculum.

* The goal of it was to create a wordpress website with presistent storage and nginx inside docker containers inside a virtual machiene.

* The used OS for the VM was Debian.

* The catch was that wordpress, nginx and mariadb had to be launched in seperate docker containers which share a network in a way so that the wordpress website is only accessible with https/port 443.

* This had to be archieved by using a docker-compose.yml in a way so that when make is called in the root of the directory, all needed services are configured and started in a error-free way.

---

## 🛠️ Requirements

Before running the project, you need to create a `.env` file in the `srcs/` directory with the following environment variables:

```env
# nginx
NGINX_PORT="443"

# mariadb
DB_ROOT_PASSWORD="  "
DB_NAME="  "
DB_USER="  "
DB_PASSWORD="  "
MARIADB_PORT="3306"

# wordpress
WORDPRESS_URL="  "
WORDPRESS_TITLE="  "
WORDPRESS_ADMIN_USER="  "
WORDPRESS_ADMIN_PASSWORD="  "
WORDPRESS_ADMIN_EMAIL="  "
WORDPRESS_USER="  "
WORDPRESS_USER_PASSWORD="  "
WORDPRESS_USER_EMAIL="  "
WORDPRESS_USER_ROLE="  "
WORDPRESS_PORT="9000"

# volumes
MARIADB_VOLUME_PATH="  "
WORDPRESS_VOLUME_PATH="  "

NETWORK_NAME="inception"

```
Replace the values with your own.

🚀 How to Run
```
git clone https://github.com/ibrahim-hajouji/inception.git
```
```
cd inception
```
```
make
```
