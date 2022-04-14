#!/bin/bash
#
# Create a shell script canary.sh that will be executed by GitHub actions.
# Canary deploy /apps/canary-v2 so they take up 50% of the client requests
# Curl the service 10 times and save the results to canary.txt
# Ensure that it is able to return results for both services
#
#Initialize the environment
#Start canary-svc
#kubectl apply -f canary-svc.yml
#Start v2
#kubectl apply -f index_v2_html.yml
#kubectl apply -f canary-v2.yml
function manual_verification {
  read -p "use command to verify: k run debug --rm -i --tty --image nicolaka/netshoot -- /bin/bash" answer

    if [[ $answer =~ ^[Yy]$ ]] ;
    then
        echo "continuing deployment"
    else
        exit
    fi
}

function canary_deploy
{
# 50% of the client requests
# define total replicas for canary deployfunction canary_deploy {
NUM_OF_V1_PODS=$(kubectl get pods -n udacity | grep -c canary-v1)
echo "V1 PODS: $NUM_OF_V1_PODS"
TARGET_V2_PODS=$NUM_OF_V1_PODS
echo "Number of V2 PODS will be deployed: $TARGET_V2_PODS"
kubectl scale deployment canary-v2 --replicas=$TARGET_V2_PODS

 # Check deployment rollout status every 1 second until complete.
ATTEMPTS=0
ROLLOUT_STATUS_CMD="kubectl rollout status deployment/canary-v2 -n udacity"
until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
    $ROLLOUT_STATUS_CMD
    ATTEMPTS=$((attempts + 1))
    sleep 1
done

NUM_OF_V1_PODS=$(kubectl get pods -n udacity | grep -c canary-v1)
echo "V1 PODS: $NUM_OF_V1_PODS"
NUM_OF_V2_PODS=$(kubectl get pods -n udacity | grep -c canary-v2)
echo "V2 PODS: $NUM_OF_V2_PODS"
echo "Canary deployment of $DEPLOY_INCREMENTS replicas successful!"  
}

kubectl apply -f canary-v2.yml
echo "verification check use: k run debug --rm -i --tty --image nicolaka/netshoot -- /bin/bash"

canary_deploy 
manual_verification