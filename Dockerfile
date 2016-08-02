FROM ubuntu:latest
MAINTAINER Ryan Boyd, <ryan.boyd@neotechnology.com>

VOLUME ["/podcast-yt-import/podcasts"]

RUN apt-get update
RUN apt-get install -y python python-pip
RUN apt-get install -y ffmpeg 
RUN apt-get install -y imagemagick
RUN pip install --upgrade pip
RUN pip install py2neo==2.0.8
RUN pip install oauth2
RUN pip install --upgrade google-api-python-client
RUN pip install pika
RUN pip install tweepy
RUN pip install futures
RUN pip install retrying

ADD get_all_podcasts.py /podcast-yt-import/
RUN chmod +x /podcast-yt-import/get_all_podcasts.py

ADD make_video.sh /podcast-yt-import/
RUN chmod +x /podcast-yt-import/make_video.sh

ADD upload_youtube.py /podcast-yt-import/
RUN chmod +x /podcast-yt-import/upload_youtube.py

ADD anno_composite.jpg /podcast-yt-import/
ADD PodcastCover-NoTitle.png /podcast-yt-import/

ADD podcasts /podcast-yt-import/podcasts/

ADD fonts /usr/share/fonts/truetype/

ADD client_secrets.json /podcast-yt-import/

WORKDIR /podcast-yt-import/

CMD ["python", "get_all_podcasts.py"]
