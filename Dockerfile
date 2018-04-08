FROM ubuntu:latest

# My customizations
RUN apt-get update && apt-get install -y locales openjdk-8-jre-headless apt-utils curl && \
    rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Set environment variables
ENV HOME /root
ENV LANG=en_US.utf8
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

# Cleaning up APT
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install NIFI
RUN cd /tmp && curl -s http://ftp.wayne.edu/apache/nifi/1.6.0/nifi-1.6.0-bin.tar.gz | tar xvz && \
    mv nifi-1.6.0 /home/nifi && cd /

# Expose ports
EXPOSE 8080

# Expose configuration and repository folders
VOLUME ["/home/nifi/conf", "/home/nifi/flowfile_repository", "/home/nifi/database_repository", "/home/nifi/content_repository", "/home/nifi/provenance_repository"]

# Start NiFi in foreground mode
CMD /home/nifi/bin/nifi.sh run