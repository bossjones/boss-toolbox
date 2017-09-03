```
$ export today=Wednesday
$ docker run -e "deep=purple" -e today --rm alpine env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=d2219b854598
deep=purple
today=Wednesday
HOME=/root
```

# other examples

```
# docker run -it --rm --name=sysdig --privileged=true \
#            --volume=/var/run/docker.sock:/host/var/run/docker.sock \
#            --volume=/dev:/host/dev \
#            --volume=/proc:/host/proc:ro \
#            --volume=/boot:/host/boot:ro \
#            --volume=/lib/modules:/host/lib/modules:ro \
#            --volume=/usr:/host/usr:ro \
#            sysdig/sysdig


# docker run -i -t --name sysdig --privileged \
# -v /var/run/docker.sock:/host/var/run/docker.sock \
# -v /dev:/host/dev \
# -v /proc:/host/proc:ro \
# -v /boot:/host/boot:ro \
# -v /lib/modules:/host/lib/modules:ro \
# -v /usr:/host/usr:ro \
# sysdig/sysdig
```
