FROM nginx/unit:latest

# copy python requirements list
COPY pythonapp/requirements.txt /config/requirements.txt

# copy node app
COPY nodeapp /nodeapp

# add Python
RUN apt update && apt install -y python3-pip    \
    && pip3 install -r /config/requirements.txt \
    && rm -rf /var/lib/apt/lists/*

# add NGINX Unit and Node.js repos
RUN apt update                                                             \
    && apt install -y apt-transport-https gnupg1                           \
    && curl https://nginx.org/keys/nginx_signing.key | apt-key add -       \
    && echo "deb https://packages.nginx.org/unit/debian/ stretch unit"     \
         > /etc/apt/sources.list.d/unit.list                               \
    && echo "deb-src https://packages.nginx.org/unit/debian/ stretch unit" \
         >> /etc/apt/sources.list.d/unit.list                              \
    && curl https://deb.nodesource.com/setup_12.x | bash -                 \
# install build chain
    && apt update                                                          \
    && apt install -y build-essential nodejs unit-dev                      \
# add global dependencies
    && npm install -g --unsafe-perm unit-http                              

# add app dependencies locally
RUN cd /nodeapp && npm install && npm link unit-http

# run unit with specified control port
CMD ["unitd", "--no-daemon", "--control", "127.0.0.1:9090"]
