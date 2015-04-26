FROM debian:jessie
MAINTAINER "Friedrich Zahn <toothstone@wh2.tu-dresden.de>"

EXPOSE 5000

RUN echo "deb http://ramses.wh2.tu-dresden.de/debian/ jessie main contrib non-free" > /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y git python python-dev python-pip libjpeg-dev libpng12-dev 
RUN pip install Pillow
RUN mkdir /flask
WORKDIR /flask
RUN git clone http://github.com/mitsuhiko/flask.git .
RUN python setup.py develop
RUN mkdir /fsikasse
WORKDIR /fsikasse
ADD / /fsikasse/
RUN ls
CMD python /fsikasse/run.py

