## Overview
 
 This is a sample project to test build of nginx container using chef cookbook
 
## Reference
http://ringo.de-smet.name/2015/03/keep-chef-out-of-your-docker-containers/

## Execution steps

### Chef cookbook setup

```bash
berks install
berks vendor chef/cookbooks
```

###Build image

  ```bash
 docker-compose up
  ```
  
###Findout container ID:

  ```bash
$ docker ps -a
CONTAINER ID        IMAGE                               COMMAND                  CREATED             STATUS                        PORTS               NAMES
35208a788ecb        chefprovisioner_nginx               "/opt/chef/bin/chef-c"   53 seconds ago      Exited (0) 18 seconds ago                         chefprovisioner_nginx_1
6d15bb8c6cc8        chefprovisioner_chefdata            "/true"                  54 seconds ago      Exited (0) 53 seconds ago                         chefprovisioner_chefdata_1
af569dd2c0b6        releasequeue/chef-client:12.0.3-1   "/bin/true"              56 seconds ago      Exited (0) 54 seconds ago                         chefprovisioner_chef_1
3a26ec8eae8d        d7bb547274d6                        "/bin/sh -c 'apt-get "   49 minutes ago      Exited (100) 48 minutes ago                       lonely_hawking
a2f58f82abaa        df0c80b315db                        "/bin/sh -c 'apt-get "   54 minutes ago      Exited (137) 53 minutes ago                       evil_darwin
ee7406123b69        df0c80b315db                        "/bin/sh -c 'apt-get "   56 minutes ago      Exited (2) 56 minutes ago                         cocky_einstein
```
###Reset entrypoint to start nginx 

   ```bash
   docker commit -c "ENTRYPOINT service nginx restart && service ssh restart && bash"  35208a788ecb  maxv/nginx23
   ```

###Run new container

  ```bash
$ docker run -i -t maxv/nginx23
 * Restarting nginx nginx                                                                                                         [ OK ] 
 * Restarting OpenBSD Secure Shell server sshd                                                                                    [ OK ] 
root@2a47e981b744:/etc/nginx# ps -ef|grep nginx
root         1     0  0 04:11 ?        00:00:00 /bin/sh -c service nginx restart && service ssh restart && bash
root        29     1  0 04:11 ?        00:00:00 nginx: master process /usr/sbin/nginx
www-data    32    29  0 04:11 ?        00:00:00 nginx: worker process
root        70    59  0 04:11 ?        00:00:00 grep --color=auto nginx

```

# Complete execution example 

```bash
$ docker-compose up
Creating chefprovisioner_chef_1
Building chefdata
Step 1 : FROM tianon/true
 ---> 410863df4943
Step 2 : COPY zero.rb first-boot.json /tmp/chef/
 ---> dd9c33a99dff
Removing intermediate container 4dd3f56f393f
Step 3 : COPY cookbooks /tmp/chef/cookbooks/
 ---> 9e100733e37e
Removing intermediate container 9e92435b7653
Step 4 : VOLUME /tmp/chef
 ---> Running in 6e8f55e199d4
 ---> d62372fdc542
Removing intermediate container 6e8f55e199d4
Successfully built d62372fdc542
Creating chefprovisioner_chefdata_1
Building nginx
Step 1 : FROM ubuntu:14.04.2
 ---> f65d74052b89
Step 2 : WORKDIR /etc/nginx
 ---> Using cache
 ---> d7bb547274d6
Step 3 : RUN apt-get update && apt-get install -y openssh-server && mkdir /var/run/sshd &&  echo 'root:screencast' | chpasswd &&  sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config &&  sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
 ---> Using cache
 ---> 6a4713e343e9
Step 4 : ENV NOTVISIBLE "in users profile"
 ---> Using cache
 ---> cc00564838d2
Step 5 : RUN echo "export VISIBLE=now" >> /etc/profile
 ---> Using cache
 ---> d50ff5554bd2
Step 6 : ENTRYPOINT service nginx restart && service ssh restart && bash
 ---> Using cache
 ---> ca01ac0b02c8
Step 7 : EXPOSE 22
 ---> Using cache
 ---> 4e18ac483255
Step 8 : EXPOSE 8080
 ---> Running in 79694b2d8093
 ---> 9db512aa5913
Removing intermediate container 79694b2d8093
Step 9 : EXPOSE 443
 ---> Running in 75991de9359d
 ---> a9e275b69118
Removing intermediate container 75991de9359d
Successfully built a9e275b69118
Creating chefprovisioner_nginx_1
Attaching to chefprovisioner_chef_1, chefprovisioner_chefdata_1, chefprovisioner_nginx_1
chefprovisioner_chef_1 exited with code 0
chefprovisioner_chefdata_1 exited with code 0
nginx_1    | [2016-01-03T04:42:14+00:00] INFO: Started chef-zero at http://localhost:8889 with repository at /tmp/chef
nginx_1    |   One version per cookbook
nginx_1    | 
nginx_1    | [2016-01-03T04:42:14+00:00] INFO: Forking chef instance to converge...
nginx_1    | [2016-01-03T04:42:14+00:00] INFO: *** Chef 12.0.3 ***
nginx_1    | [2016-01-03T04:42:14+00:00] INFO: Chef-client pid: 11
nginx_1    | [2016-01-03T04:42:15+00:00] INFO: HTTP Request Returned 404 Not Found : Object not found: http://localhost:8889/nodes/35208a788ecb
nginx_1    | [2016-01-03T04:42:15+00:00] INFO: Setting the run_list to ["recipe[nginx::default]"] from CLI options
nginx_1    | [2016-01-03T04:42:15+00:00] INFO: Run List is [recipe[nginx::default]]
nginx_1    | [2016-01-03T04:42:15+00:00] INFO: Run List expands to [nginx::default]
nginx_1    | [2016-01-03T04:42:15+00:00] INFO: Starting Chef Run for 35208a788ecb
nginx_1    | [2016-01-03T04:42:15+00:00] INFO: Running start handlers
nginx_1    | [2016-01-03T04:42:15+00:00] INFO: Start handlers complete.
nginx_1    | [2016-01-03T04:42:15+00:00] INFO: HTTP Request Returned 404 Not Found : Object not found: /reports/nodes/35208a788ecb/runs
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Loading cookbooks [nginx@2.7.6, apt@2.9.2, bluepill@2.4.1, build-essential@2.2.4, ohai@2.0.4, runit@1.7.6, yum-epel@0.6.5, rsyslog@2.2.0, packagecloud@0.1.1, yum@3.8.2]
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/http_echo_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/commons_dir.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/socketproxy.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/repo.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/http_realip_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/authorized_ips.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/http_mp4_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/ipv6.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/http_ssl_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/naxsi_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/ngx_devel_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/set_misc.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/package.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/ohai_plugin.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/http_gzip_static_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/commons_conf.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/ngx_lua_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/source.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/http_auth_request_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/headers_more_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/commons_script.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/http_perl_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/syslog_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/http_stub_status_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/passenger.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/openssl_source.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/upload_progress_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:16+00:00] INFO: Storing updated cookbooks/nginx/recipes/lua.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/recipes/repo_passenger.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/recipes/pagespeed_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/recipes/commons.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/recipes/http_spdy_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/echo.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/recipes/http_geoip_module.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/libraries/matchers.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/definitions/nginx_site.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/socketproxy.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/syslog.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/repo.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/headers_more.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/set_misc.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/upload_progress.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/devel.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/source.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/geoip.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/status.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/naxsi.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/lua.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/rate_limiting.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/openssl_source.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/auth_request.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/passenger.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/files/default/mime.types in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/attributes/pagespeed.rb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/files/default/naxsi_core.rules in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/ubuntu/nginx.init.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/gentoo/nginx.init.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/default/modules/http_realip.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/default/modules/http_gzip_static.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/default/modules/nginx_status.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/debian/nginx.init.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/default/modules/upload_progress.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/suse/nginx.init.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/default/modules/socketproxy.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/default/modules/authorized_ip.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/default/nginx.init.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/default/sv-nginx-log-run.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/default/modules/passenger.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/default/default-site.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/default/nginx.pill.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/default/modules/http_geoip.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:17+00:00] INFO: Storing updated cookbooks/nginx/templates/default/plugins/nginx.rb.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/nginx/templates/default/sv-nginx-run.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/resources/preference.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/nginx/templates/default/nginx.sysconfig.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/nginx/README.md in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/nginx/templates/default/nxensite.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/nginx/templates/default/nginx.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/nginx/metadata.json in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/nginx/templates/default/nxdissite.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/nginx/CHANGELOG.md in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/nginx/templates/default/nginx-upstart.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/resources/repository.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/recipes/cacher-ng.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/providers/repository.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/recipes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/libraries/network.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/providers/preference.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/libraries/matchers.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/recipes/unattended-upgrades.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/recipes/cacher-client.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/files/default/apt-proxy-v2.conf in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/templates/debian-6.0/acng.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/libraries/helpers.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/files/default/15update-stamp in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/templates/default/01proxy.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/templates/ubuntu-10.04/acng.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/attributes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/templates/default/10recommends.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/templates/default/20auto-upgrades.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/templates/default/50unattended-upgrades.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/README.md in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/templates/default/unattended-upgrades.seed.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/metadata.json in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/templates/default/acng.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/bluepill/providers/service.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/bluepill/resources/service.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/apt/CHANGELOG.md in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/bluepill/templates/default/bluepill_rsyslog.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/bluepill/recipes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/bluepill/templates/default/bluepill_init.lsb.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/bluepill/attributes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/bluepill/templates/default/bluepill_init.rhel.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/bluepill/recipes/rsyslog.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/bluepill/templates/default/bluepill_init.fedora.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/bluepill/templates/default/bluepill_init.freebsd.erb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/bluepill/README.md in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/build-essential/recipes/_solaris2.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/build-essential/recipes/_omnios.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/build-essential/recipes/_suse.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/bluepill/CHANGELOG.md in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/build-essential/recipes/_debian.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/build-essential/recipes/_freebsd.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/build-essential/recipes/_fedora.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/bluepill/metadata.json in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/build-essential/recipes/_smartos.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/build-essential/recipes/_mac_os_x.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/build-essential/recipes/_rhel.rb in the cache.
nginx_1    | [2016-01-03T04:42:18+00:00] INFO: Storing updated cookbooks/build-essential/recipes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/build-essential/libraries/timing.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/build-essential/CHANGELOG.md in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/build-essential/attributes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/build-essential/libraries/xcode_command_line_tools.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/build-essential/metadata.json in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/ohai/resources/hint.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/build-essential/libraries/matchers.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/build-essential/README.md in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/ohai/providers/hint.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/ohai/recipes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/recipes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/libraries/matchers.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/ohai/CHANGELOG.md in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/ohai/metadata.json in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/libraries/provider_runit_service.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/ohai/attributes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/ohai/files/default/plugins/README in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/libraries/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/ohai/libraries/matchers.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/ohai/README.md in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/libraries/helpers.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/files/ubuntu-7.04/runsvdir in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/files/default/runsvdir in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/files/default/runit.seed in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/libraries/resource_runit_service.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/attributes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/files/ubuntu-6.10/runsvdir in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/templates/debian/init.d.erb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/files/ubuntu-8.04/runsvdir in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/files/ubuntu-7.10/runsvdir in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/templates/gentoo/runit-start.sh.erb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/README.md in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/metadata.json in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/CHANGELOG.md in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/yum-epel/recipes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/runit/templates/default/log-config.erb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/yum-epel/attributes/epel-testing-source.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/yum-epel/attributes/epel-testing.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/yum-epel/attributes/epel-testing-debuginfo.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/yum-epel/attributes/epel-source.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/yum-epel/attributes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/yum-epel/attributes/epel.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/yum-epel/attributes/epel-debuginfo.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/yum-epel/MAINTAINERS.md in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/yum-epel/CONTRIBUTING.md in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/yum-epel/CHANGELOG.md in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/yum-epel/README.md in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/rsyslog/providers/file_input.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/yum-epel/metadata.json in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/rsyslog/resources/file_input.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/rsyslog/recipes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/rsyslog/templates/default/file-input.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/rsyslog/templates/default/49-remote.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/rsyslog/recipes/server.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/rsyslog/attributes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/rsyslog/recipes/client.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/rsyslog/templates/smartos/50-default.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/rsyslog/libraries/helpers.rb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/rsyslog/templates/default/rsyslog.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:19+00:00] INFO: Storing updated cookbooks/rsyslog/templates/default/49-relp.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/rsyslog/templates/default/omnios-manifest.xml.erb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/rsyslog/CHANGELOG.md in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/rsyslog/README.md in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/rsyslog/templates/default/50-default.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/packagecloud/libraries/helper.rb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/rsyslog/metadata.json in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/packagecloud/libraries/matcher.rb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/rsyslog/templates/default/35-server-per-host.conf.erb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/packagecloud/providers/repo.rb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/packagecloud/templates/default/apt.erb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/packagecloud/resources/repo.rb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/packagecloud/attributes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/packagecloud/CHANGELOG.md in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/yum/resources/repository.rb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/packagecloud/templates/.kitchen/logs/kitchen.log in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/yum/resources/globalconfig.rb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/packagecloud/README.md in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/packagecloud/templates/default/yum.erb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/packagecloud/metadata.json in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/yum/templates/default/main.erb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/yum/providers/repository.rb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/yum/providers/globalconfig.rb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/yum/recipes/default.rb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/yum/attributes/main.rb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/yum/templates/default/repo.erb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/yum/libraries/matchers.rb in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/yum/README.md in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/yum/metadata.json in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Storing updated cookbooks/yum/CHANGELOG.md in the cache.
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: ohai plugins will be at: /etc/chef/ohai_plugins
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Processing remote_directory[/etc/chef/ohai_plugins for cookbook ohai] action create (ohai::default line 32)
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: remote_directory[/etc/chef/ohai_plugins for cookbook ohai] created directory /etc/chef/ohai_plugins
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: remote_directory[/etc/chef/ohai_plugins for cookbook ohai] mode changed to 755
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Processing cookbook_file[/etc/chef/ohai_plugins/README] action create (dynamically defined)
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: cookbook_file[/etc/chef/ohai_plugins/README] created file /etc/chef/ohai_plugins/README
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: cookbook_file[/etc/chef/ohai_plugins/README] updated file contents /etc/chef/ohai_plugins/README
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: cookbook_file[/etc/chef/ohai_plugins/README] mode changed to 644
nginx_1    | [2016-01-03T04:42:20+00:00] INFO: Processing ohai[custom_plugins] action reload (ohai::default line 46)
nginx_1    | [2016-01-03T04:42:21+00:00] INFO: ohai[custom_plugins] reloaded
nginx_1    | [2016-01-03T04:42:21+00:00] WARN: Cloning resource attributes for service[nginx] from prior resource (CHEF-3694)
nginx_1    | [2016-01-03T04:42:21+00:00] WARN: Previous service[nginx]: /tmp/chef/local-mode-cache/cache/cookbooks/nginx/recipes/package.rb:47:in `from_file'
nginx_1    | [2016-01-03T04:42:21+00:00] WARN: Current  service[nginx]: /tmp/chef/local-mode-cache/cache/cookbooks/nginx/recipes/default.rb:24:in `from_file'
nginx_1    | [2016-01-03T04:42:21+00:00] INFO: Processing ohai[reload_nginx] action nothing (nginx::ohai_plugin line 22)
nginx_1    | [2016-01-03T04:42:21+00:00] INFO: Processing template[/etc/chef/ohai_plugins/nginx.rb] action create (nginx::ohai_plugin line 27)
nginx_1    | [2016-01-03T04:42:21+00:00] INFO: template[/etc/chef/ohai_plugins/nginx.rb] created file /etc/chef/ohai_plugins/nginx.rb
nginx_1    | [2016-01-03T04:42:21+00:00] INFO: template[/etc/chef/ohai_plugins/nginx.rb] updated file contents /etc/chef/ohai_plugins/nginx.rb
nginx_1    | [2016-01-03T04:42:21+00:00] INFO: template[/etc/chef/ohai_plugins/nginx.rb] owner changed to 0
nginx_1    | [2016-01-03T04:42:21+00:00] INFO: template[/etc/chef/ohai_plugins/nginx.rb] group changed to 0
nginx_1    | [2016-01-03T04:42:21+00:00] INFO: template[/etc/chef/ohai_plugins/nginx.rb] mode changed to 755
nginx_1    | [2016-01-03T04:42:21+00:00] INFO: template[/etc/chef/ohai_plugins/nginx.rb] sending reload action to ohai[reload_nginx] (immediate)
nginx_1    | [2016-01-03T04:42:21+00:00] INFO: Processing ohai[reload_nginx] action reload (nginx::ohai_plugin line 22)
nginx_1    | [2016-01-03T04:42:21+00:00] WARN: [DEPRECATION] Plugin at /etc/chef/ohai_plugins/nginx.rb is a version 6 plugin. Version 6 plugins will not be supported in future releases of Ohai. Please upgrade your plugin to version 7 plugin syntax. For more information visit here: docs.opscode.com/ohai_custom.html
nginx_1    | [2016-01-03T04:42:21+00:00] INFO: ohai[reload_nginx] reloaded
nginx_1    | [2016-01-03T04:42:21+00:00] INFO: Processing remote_directory[/etc/chef/ohai_plugins for cookbook ohai] action nothing (ohai::default line 32)
nginx_1    | [2016-01-03T04:42:21+00:00] INFO: Processing ohai[custom_plugins] action nothing (ohai::default line 46)
nginx_1    | [2016-01-03T04:42:21+00:00] INFO: Processing apt_package[nginx] action install (nginx::package line 41)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: apt_package[nginx] sending reload action to ohai[reload_nginx] (immediate)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: Processing ohai[reload_nginx] action reload (nginx::ohai_plugin line 22)
nginx_1    | [2016-01-03T04:42:45+00:00] WARN: [DEPRECATION] Plugin at /etc/chef/ohai_plugins/nginx.rb is a version 6 plugin. Version 6 plugins will not be supported in future releases of Ohai. Please upgrade your plugin to version 7 plugin syntax. For more information visit here: docs.opscode.com/ohai_custom.html
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: ohai[reload_nginx] reloaded
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: Processing service[nginx] action enable (nginx::package line 47)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: Processing directory[/etc/nginx] action create (nginx::commons_dir line 22)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: Processing directory[/var/log/nginx] action create (nginx::commons_dir line 29)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: Processing directory[/run] action create (nginx::commons_dir line 36)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: Processing directory[/etc/nginx/sites-available] action create (nginx::commons_dir line 44)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: Processing directory[/etc/nginx/sites-enabled] action create (nginx::commons_dir line 44)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: Processing directory[/etc/nginx/conf.d] action create (nginx::commons_dir line 44)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: Processing template[/usr/sbin/nxensite] action create (nginx::commons_script line 23)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[/usr/sbin/nxensite] created file /usr/sbin/nxensite
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[/usr/sbin/nxensite] updated file contents /usr/sbin/nxensite
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[/usr/sbin/nxensite] owner changed to 0
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[/usr/sbin/nxensite] group changed to 0
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[/usr/sbin/nxensite] mode changed to 755
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: Processing template[/usr/sbin/nxdissite] action create (nginx::commons_script line 23)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[/usr/sbin/nxdissite] created file /usr/sbin/nxdissite
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[/usr/sbin/nxdissite] updated file contents /usr/sbin/nxdissite
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[/usr/sbin/nxdissite] owner changed to 0
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[/usr/sbin/nxdissite] group changed to 0
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[/usr/sbin/nxdissite] mode changed to 755
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: Processing template[nginx.conf] action create (nginx::commons_conf line 22)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[nginx.conf] backed up to /tmp/chef/local-mode-cache/backup/etc/nginx/nginx.conf.chef-20160103044245.861147
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[nginx.conf] updated file contents /etc/nginx/nginx.conf
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: Processing template[/etc/nginx/sites-available/default] action create (nginx::commons_conf line 32)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[/etc/nginx/sites-available/default] backed up to /tmp/chef/local-mode-cache/backup/etc/nginx/sites-available/default.chef-20160103044245.870618
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[/etc/nginx/sites-available/default] updated file contents /etc/nginx/sites-available/default
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[/etc/nginx/sites-available/default] not queuing delayed action reload on service[nginx] (delayed), as it's already been queued
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: Processing execute[nxensite default] action run (nginx::commons_conf line 32)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: Processing service[nginx] action start (nginx::default line 24)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: service[nginx] started
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: template[nginx.conf] sending reload action to service[nginx] (delayed)
nginx_1    | [2016-01-03T04:42:45+00:00] INFO: Processing service[nginx] action reload (nginx::default line 24)
nginx_1    | [2016-01-03T04:42:46+00:00] INFO: service[nginx] reloaded
nginx_1    | [2016-01-03T04:42:46+00:00] INFO: Chef Run complete in 30.877935682 seconds
nginx_1    | [2016-01-03T04:42:46+00:00] INFO: Running report handlers
nginx_1    | [2016-01-03T04:42:46+00:00] INFO: Report handlers complete
chefprovisioner_nginx_1 exited with code 0
Gracefully stopping... (press Ctrl+C again to force)
$ docker ps -a
CONTAINER ID        IMAGE                               COMMAND                  CREATED             STATUS                        PORTS               NAMES
35208a788ecb        chefprovisioner_nginx               "/opt/chef/bin/chef-c"   53 seconds ago      Exited (0) 18 seconds ago                         chefprovisioner_nginx_1
6d15bb8c6cc8        chefprovisioner_chefdata            "/true"                  54 seconds ago      Exited (0) 53 seconds ago                         chefprovisioner_chefdata_1
af569dd2c0b6        releasequeue/chef-client:12.0.3-1   "/bin/true"              56 seconds ago      Exited (0) 54 seconds ago                         chefprovisioner_chef_1
3a26ec8eae8d        d7bb547274d6                        "/bin/sh -c 'apt-get "   49 minutes ago      Exited (100) 48 minutes ago                       lonely_hawking
a2f58f82abaa        df0c80b315db                        "/bin/sh -c 'apt-get "   54 minutes ago      Exited (137) 53 minutes ago                       evil_darwin
ee7406123b69        df0c80b315db                        "/bin/sh -c 'apt-get "   56 minutes ago      Exited (2) 56 minutes ago                         cocky_einstein
$ docker commit -c "ENTRYPOINT service nginx restart && service ssh restart && bash" 35208a788ecb    maxv/nginx234
0ee0081b63e4786549a270be25ddee947e41c121130438b51906a6ef80288837
$ docker run -i -t maxv/nginx234
 * Restarting nginx nginx                                                                                                         [ OK ] 
 * Restarting OpenBSD Secure Shell server sshd                                                                                    [ OK ] 
root@c059bbe497e0:/etc/nginx# netstat -antp           
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN      32/nginx        
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      59/sshd         
tcp6       0      0 :::22                   :::*                    LISTEN      59/sshd         
root@c059bbe497e0:/etc/nginx# 

  ```
  
- Connect to the docker-machine and Validate container:
  
  ```bash
$ docker-machine ssh default
                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
           \______ o           __/
             \    \         __/
              \____\_______/
 _                 _   ____     _            _
| |__   ___   ___ | |_|___ \ __| | ___   ___| | _____ _ __
| '_ \ / _ \ / _ \| __| __) / _` |/ _ \ / __| |/ / _ \ '__|
| |_) | (_) | (_) | |_ / __/ (_| | (_) | (__|   <  __/ |
|_.__/ \___/ \___/ \__|_____\__,_|\___/ \___|_|\_\___|_|
Boot2Docker version 1.9.0, build master : 16e4a2a - Tue Nov  3 19:49:22 UTC 2015
Docker version 1.9.0, build 76d6bc9
docker@default:~$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS                       NAMES
c059bbe497e0        maxv/nginx234       "/bin/sh -c 'service "   About a minute ago   Up About a minute   22/tcp, 443/tcp, 8080/tcp   happy_hawking
docker@default:~$ docker inspect c059bbe497e0 |grep IPA
        "SecondaryIPAddresses": null,
        "IPAddress": "172.17.0.2",
                "IPAddress": "172.17.0.2",
docker@default:~$ curl 172.17.0.2:8080
<html>
<head><title>404 Not Found</title></head>
<body bgcolor="white">
<center><h1>404 Not Found</h1></center>
<hr><center>nginx/1.4.6 (Ubuntu)</center>
</body>
</html>
docker@default:~$ 

  ```
  
  # Clean up
  To remove images/containers execute below commands. you need to run these commands every time you want to rebuild container.
  ```bash
  docker-compose rm
  docker images | grep chefprovisioner  |  awk  ' { print $3 } ' | xargs docker rmi -f
  ```
