config_perf:
	sudo sh -c 'echo 1 >/proc/sys/kernel/perf_event_paranoid'
	sudo sh -c 'echo kernel.perf_event_paranoid=1 > /etc/sysctl.d/00-local.conf'

build:
	docker build --rm -t bossjones/boss-toolbox:latest .

tag:
	docker tag bossjones/bossjones/boss-toolbox:latest

build-push: build tag
	docker push bossjones/bossjones/boss-toolbox:latest
