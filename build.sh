#!/bin/sh
BUILDX_GIT_INFO=false PASSWORD=docker docker buildx build -t maddn-dev --secret id=PASSWORD,env=PASSWORD .
