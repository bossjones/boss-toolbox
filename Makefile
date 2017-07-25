config_perf:
	sudo sh -c 'echo 1 >/proc/sys/kernel/perf_event_paranoid'
	sudo sh -c 'echo kernel.perf_event_paranoid=1 > /etc/sysctl.d/00-local.conf'

build:
	docker build --rm -t bossjones/boss-toolbox:latest .

build-force:
	docker build --rm --force-rm --pull --no-cache -t bossjones/boss-toolbox:latest .

tag:
	docker tag bossjones/boss-toolbox:latest bossjones/boss-toolbox:latest

build-push: build tag
	docker push bossjones/boss-toolbox:latest

# ipc: IPC (POSIX/SysV IPC) namespace provides separation of named shared memory segments, semaphores and message queues.
run:
	docker run -it --rm --name boss-toolbox --privileged \
	               --ipc=host --net=host --pid=host \
				   -e HOST=/host \
				   -e NAME=boss-toolbox \
				   -e IMAGE=bossjones:boss-toolbox \
				   -v /run:/run \
				   -v /var/log:/var/log \
				   -v /etc/localtime:/etc/localtime \
				   -v /:/host \
				   bossjones/boss-toolbox


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
