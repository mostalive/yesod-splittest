#!/bin/env bash

createdb -O splittest splittest_test &&\
psql --command "grant all privileges on database splittest_test to splittest;" 
