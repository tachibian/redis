#Dockerfile for redis-2.8.17

FROM skcho4docker/redis-2.8.17:ver0.0.2
MAINTAINER Sangki Cho
ADD start.sh /home/redis/start.sh
RUN chown redis:redis /home/redis/start.sh; chmod 755 /home/redis/start.sh
ENV HOME /home/redis
USER redis
WORKDIR /home/redis
EXPOSE 6379
ENTRYPOINT ["/bin/bash","/home/redis/start.sh"]
CMD ["exec"]

