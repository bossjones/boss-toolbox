# boss-toolbox

[![Build Status](https://travis-ci.org/bossjones/boss-toolbox.svg?branch=master)](https://travis-ci.org/bossjones/boss-toolbox)

Bunch of tools I like to use for debugging shit


# FAQ

Q: I tried to run perf and I got this. What do I do?:

```
perf stat ls
Error:
You may not have permission to collect stats.
Consider tweaking /proc/sys/kernel/perf_event_paranoid:
 -1 - Not paranoid at all
  0 - Disallow raw tracepoint access for unpriv
  1 - Disallow cpu events for unpriv
  2 - Disallow kernel profiling for unpriv
```

A: On your host ( READ: Not docker container ), run the following:

`sudo sh -c 'echo 1 >/proc/sys/kernel/perf_event_paranoid'`

or

`sysctl -w kernel.perf_event_paranoid="1"`


**PERSIST REBOOTS:**

`sudo sh -c 'echo kernel.perf_event_paranoid=1 > /etc/sysctl.d/00-local.conf'`


Q: What does any of that stuff mean?

*source: https://unix.stackexchange.com/questions/14227/do-i-need-root-admin-permissions-to-run-userspace-perf-tool-perf-events-ar*

What you can do with perf without being root depends on the `kernel.perf_event_paranoid` sysctl setting.

`kernel.perf_event_paranoid` = 2: you can't take any measurements. The perf utility might still be useful to analyse existing records with perf ls, perf report, perf timechart or perf trace.

`kernel.perf_event_paranoid` = 1: you can trace a command with perf stat or perf record, and get kernel profiling data.

`kernel.perf_event_paranoid` = 0: you can trace a command with perf stat or perf record, and get CPU event data.

`kernel.perf_event_paranoid` = -1: you get raw access to kernel tracepoints (specifically, you can `mmap` the file created by `perf_event_open`, I don't know what the implications are).


Q: Can you explain why you chose those docker run settings?


```
--ipc=host

By default, all containers have the IPC namespace enabled.

IPC (POSIX/SysV IPC) namespace provides separation of named shared memory segments, semaphores and message queues.

Shared memory segments are used to accelerate inter-process communication at memory speed, rather than through pipes or through the network stack. Shared memory is commonly used by databases and custom-built (typically C/OpenMPI, C++/using boost libraries) high performance applications for scientific computing and financial services industries. If these types of applications are broken into multiple containers, you might need to share the IPC mechanisms of the containers.
```

```
--net=host

--network="bridge" : Connect a container to a network
                      'bridge': create a network stack on the default Docker bridge
                      'none': no networking
                      'container:<name|id>': reuse another container's network stack
                      'host': use the Docker host network stack
                      '<network-name>|<network-id>': connect to a user-defined network
```

```
--pid=host

By default, all containers have the PID namespace enabled.

PID namespace provides separation of processes. The PID Namespace removes the view of the system processes, and allows process ids to be reused including pid 1.

In certain cases you want your container to share the host’s process namespace, basically allowing processes within the container to see all of the processes on the system. For example, you could build a container with debugging tools like strace or gdb, but want to use these tools when debugging processes within the container.
```

```
Additionally, the operator can set any environment variable in the container by using one or more -e flags, even overriding those mentioned above, or already defined by the developer with a Dockerfile ENV. If the operator names an environment variable without specifying a value, then the current value of the named variable is propagated into the container’s environment:
```


https://www.projectatomic.io/blog/2015/09/introducing-the-fedora-tools-image-for-fedora-atomic-host/


https://fedoraproject.org/wiki/StackTraces
