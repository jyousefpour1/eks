#!/bin/bash
kubectl apply -f redis-master.yml
sleep 10
kubectl apply -f redis-slaves.yml
sleep 10
kubectl apply -f frontend.yml