#!/bin/bash

# Install prequities if not yet installed
command -v jq >/dev/null 2>&1 || {
  echo >&2 "Installing jq...";
  brew install jq
}

STATUS_TO_WAIT='running'
SSH_HOST=''
SSH_PORT=''

echo Finding offers
OFFERS="$(vastai search offers 'num_gpus=1 dph<0.06 storage_cost<2 rented=False' --on-demand --storage 16)"
OFFER_ID=$(awk 'NR==2{print $1}' <<< "${OFFERS}")
echo "$OFFERS"

echo
echo "Picking offer id=${OFFER_ID}"


echo
echo Creating instance
# Examples:
# vastai create instance 6995713 --image pytorch/pytorch --disk 40 --env '-p 8081:80801/udp -h billybob' --ssh --direct --onstart-cmd "env | grep _ >> /etc/environment; echo 'starting up'";
# vastai create instance 384827  --image bobsrepo/pytorch:latest --login '-u bob -p 9d8df!fd89ufZ docker.io' --jupyter --direct --env '-e TZ=PDT -e XNAME=XX4 -p 22:22 -p 8080:8080' --disk 20
IMAGE_TAG='nvidia/cuda:12.5.1-cudnn-devel-ubuntu22.04'
DISK_SIZE=16
OPTIONS='--ssh --jupyter --jupyter-lab'
ENV_VARS="-e DATA_DIRECTORY=/workspace/ -e JUPYTER_DIR=/"
CREATE_RESPONSE="$(vastai create instance ${OFFER_ID} --raw --image ${IMAGE_TAG} --disk ${DISK_SIZE} ${OPTIONS} --env "${ENV_VARS}" --onstart onstart.sh)"
echo "$CREATE_RESPONSE"
INSTANCE_ID="$(jq -r '.new_contract' <<< "$CREATE_RESPONSE")"
echo "Created instance id=${INSTANCE_ID}"


echo
echo Waiting for an instance to start...
start=`date +%s`
while true; do
  # Execute the command and capture its output
  STATUS_RESPONSE=$(vastai show instance ${INSTANCE_ID} --raw)
  STATUS=$(jq -r '.actual_status' <<< "$STATUS_RESPONSE")
  # Check correct status
  if [[ "$STATUS" == "$STATUS_TO_WAIT" ]]; then
    echo
    echo "Success: status is '${STATUS}'."
    SSH_HOST=$(jq -r '.ssh_host' <<< "$STATUS_RESPONSE")
    SSH_PORT=$(jq -r '.ssh_port' <<< "$STATUS_RESPONSE")
    break
  fi

  printf '.'
  sleep 5
done
end=`date +%s`
runtime=$((end-start))
echo "Done in ${runtime} seconds"


echo
echo Waiting for an instance to complete provisioning...
start=`date +%s`
while true; do
  # Execute the command and capture its output
  INSTANCE_LOGS=$(vastai logs ${INSTANCE_ID})
  # Wait for final message
  if grep -q "Caralho" <<< "$INSTANCE_LOGS"; then
    echo
    echo "Success: provisioning is done"
    break
  fi

  printf '.'
  sleep 5
done
end=`date +%s`
runtime=$((end-start))
echo "Done in ${runtime} seconds"

echo
echo "ssh -p ${SSH_PORT} root@${SSH_HOST} -L 8080:localhost:8080"
