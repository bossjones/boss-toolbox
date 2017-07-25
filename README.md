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


**PERSIST REBOOTS:**

`sudo sh -c 'echo kernel.perf_event_paranoid=1 > /etc/sysctl.d/local.conf'`


Q: What does any of that stuff mean?

*source: https://unix.stackexchange.com/questions/14227/do-i-need-root-admin-permissions-to-run-userspace-perf-tool-perf-events-ar*

What you can do with perf without being root depends on the `kernel.perf_event_paranoid` sysctl setting.

`kernel.perf_event_paranoid` = 2: you can't take any measurements. The perf utility might still be useful to analyse existing records with perf ls, perf report, perf timechart or perf trace.

`kernel.perf_event_paranoid` = 1: you can trace a command with perf stat or perf record, and get kernel profiling data.

`kernel.perf_event_paranoid` = 0: you can trace a command with perf stat or perf record, and get CPU event data.

`kernel.perf_event_paranoid` = -1: you get raw access to kernel tracepoints (specifically, you can `mmap` the file created by `perf_event_open`, I don't know what the implications are).
