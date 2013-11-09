#!/bin/bash
kill -s SIGUSR2 `cat /tmp/puma.pid`