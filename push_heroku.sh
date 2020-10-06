#!/usr/bin/env bash

docker build -t my-devel-app .;
heroku container:push web --app my-devel-app && heroku container:release web --app my-devel-app;