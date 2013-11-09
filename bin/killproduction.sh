#!/bin/bash
kill -s SIGTERM `cat /tmp/puma.pid`
