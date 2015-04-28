FROM python:wheezy
MAINTAINER "Friedrich Zahn <toothstone@wh2.tu-dresden.de>"

EXPOSE 80

RUN echo "deb http://ramses.wh2.tu-dresden.de/debian/ wheezy main contrib non-free" > /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y && apt-get install -y git libjpeg-dev libpng12-dev sqlite3 nginx 
RUN pip install Pillow Flask uwsgi
RUN mkdir /fsikasse
WORKDIR /fsikasse
ADD / /fsikasse/
RUN rm kasse.db && sqlite3 kasse.db < schema.sql
RUN rm /etc/nginx/sites-enabled/*
ADD /nginx.conf /etc/nginx/sites-enabled/mateduct.conf
CMD service nginx start && uwsgi --ini /fsikasse/uwsgi.ini 

