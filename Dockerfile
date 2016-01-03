FROM ubuntu:14.04.2

# Install Nginx.
#RUN \
#  rm -rf /var/lib/apt/lists/* && \
#  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
#  chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
# VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
#CMD ["nginx"]

RUN \
 apt-get update && apt-get install -y openssh-server &&\
 mkdir /var/run/sshd && \
 echo 'root:screencast' | chpasswd && \
 sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
 sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

ENTRYPOINT service nginx restart && service ssh restart && bash
# Expose ports.
EXPOSE 22
EXPOSE 8080
EXPOSE 443
