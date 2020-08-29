#!/usr/bin/env bash

export DBIC_TRACE=1
export DBIC_TRACE_PROFILE=/backend/start_catalyst/dbic.json
export CATALYST_DEBUG=1

START_PL=/backend/MyApp/script/server.pl;
if [ $1 ]; then
    START_PL=$1;
fi

unbuffer perl $START_PL --debug --port $PORT --restart --restart_delay 1;
