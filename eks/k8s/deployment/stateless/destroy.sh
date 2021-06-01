#!/bin/bash
kubectl delete -f redis-master.yml
sleep 10
kubectl delete -f redis-slaves.yml
sleep 10
kubectl delete -f frontend.yml