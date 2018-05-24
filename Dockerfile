FROM centos:7

ADD assets /assets
RUN /assets/setup.sh

EXPOSE 1521
EXPOSE 8080

USER 1000

CMD /usr/sbin/startup.sh && tail -f /dev/null
