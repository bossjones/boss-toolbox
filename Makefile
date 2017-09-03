username := bossjones
container_name := boss-toolbox

GIT_BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
GIT_SHA     = $(shell git rev-parse HEAD)
BUILD_DATE  = $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

config-perf:
	sudo sh -c 'echo 1 >/proc/sys/kernel/perf_event_paranoid'
	sudo sh -c 'echo kernel.perf_event_paranoid=1 > /etc/sysctl.d/00-local.conf'

build:
	docker build --rm -t $(username)/$(container_name):latest .

build-force:
	docker build --rm --force-rm --pull --no-cache -t $(username)/$(container_name):latest .

tag:
	docker tag $(username)/$(container_name):latest $(username)/$(container_name):latest

build-push: build tag
	docker push $(username)/$(container_name):latest

push:
	docker push $(username)/$(container_name):latest

push-force: build-force push

# ipc: IPC (POSIX/SysV IPC) namespace provides separation of named shared memory segments, semaphores and message queues.
run:
	docker run -it --rm --name $(container_name) --privileged \
	               --ipc=host --net=host --pid=host \
				   -e HOST=/host \
				   -e NAME=$(container_name) \
				   -e IMAGE=$(username):$(container_name) \
				   -v /run:/run \
				   -v /var/log:/var/log \
				   -v /etc/localtime:/etc/localtime \
				   -v /:/host \
				   $(username)/$(container_name)
