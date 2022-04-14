#!/bin/bash

function green_deploy
{
# deploy the same number of greens as blues
NUM_OF_BLUE_PODS=$(kubectl get pods -n udacity | grep -c blue)
echo "BLUE PODS: $NUM_OF_BLUE_PODS"
TARGET_GREEN_PODS=$NUM_OF_BLUE_PODS
echo "Number of GREEN PODS will be deployed: $TARGET_GREEN_PODS"
kubectl scale deployment green --replicas=$TARGET_GREEN_PODS

 # Check deployment rollout status every 1 second until complete.
ATTEMPTS=0
ROLLOUT_STATUS_CMD="kubectl rollout status deployment/green -n udacity"
until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
    $ROLLOUT_STATUS_CMD
    ATTEMPTS=$((attempts + 1))
    sleep 1
done

NUM_OF_BLUE_PODS=$(kubectl get pods -n udacity | grep -c blue)
echo "BLUE PODS: $NUM_OF_BLUE_PODS"
NUM_OF_GREEN_PODS=$(kubectl get pods -n udacity | grep -c green)
echo "GREEN PODS: $NUM_OF_GREEN_PODS"
echo "Green deployment of $DEPLOY_INCREMENTS replicas successful!"  
}

kubectl apply -f green.yml
green_deploy 