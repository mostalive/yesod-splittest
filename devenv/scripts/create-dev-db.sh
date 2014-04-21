#!/bin/env bash

psql --command "CREATE USER splittest WITH LOGIN PASSWORD 'splittest';" &&\
createdb -O splittest splittest &&\
psql --command "grant all privileges on database splittest to splittest;" 
