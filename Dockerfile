FROM alpine
MAINTAINER Christian Gatzlaff <cgatzlaff@gmail.com>

# basic flask environment
RUN apk add --no-cache bash git nginx uwsgi uwsgi-python3 \
	&& pip3 install --upgrade pip \
	&& pip3 install flask flask_sqlalchemy==2.1.0 \
        flask-restful==0.3.6 flask-cors==3.0.7 \
        flask-cache==0.13.1 flask-marshmallow==0.9.0

# application folder
ENV APP_DIR /app

# app dir
RUN mkdir ${APP_DIR} \
	&& chown -R nginx:nginx ${APP_DIR} \
	&& chmod 777 /run/ -R \
	&& chmod 777 /root/ -R
VOLUME [${APP_DIR}]
WORKDIR ${APP_DIR}

# expose web server port
# only http, for ssl use reverse proxy
EXPOSE 80

# copy config files into filesystem
COPY nginx.conf /etc/nginx/nginx.conf
COPY app.ini /app.ini
COPY entrypoint.sh /entrypoint.sh

# exectute start up script
ENTRYPOINT ["/entrypoint.sh"]
