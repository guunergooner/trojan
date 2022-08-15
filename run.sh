#!/bin/bash

registry_url=${registry_url:-gooner}
image_name=${image_name:-trojan}
image_tag=${image_tag:-v1.16.0}
container_name=${container_name:-trojan-client}
local_addr=${local_addr:-0.0.0.0}
local_port=${local_port:-1080}
listen_port=${listen_port:-2080}

function build_image () {
    docker build -t ${registry_url}/${image_name}:${image_tag} \
        -f Dockerfile .
}

function push_image () {
    docker push ${registry_url}/${image_name}:${image_tag}
}

function run_container () {
    docker run -itd \
        -p ${listen_port}:${local_port} \
        -v $(pwd)/config.json:/trojan/config.json \
        -v $(pwd)/fullchain.cer:/trojan/fullchain.cer \
        --name=${container_name} \
        ${registry_url}/${image_name}:${image_tag}
}

function remove_container () {
    docker rm -f ${container_name}
}

show_help () {
cat << USAGE
usage: $0 [ -o build/push/run/remove ]

    -h : Help info
    -o : Run options

USAGE
exit 0
}

# Get Opts
while getopts "ho:" opt; do
    case "$opt" in
    h)  show_help
        ;;
    o)  OPTION=$OPTARG
        ;;
    ?)  show_help
        ;;
    esac
done

case "${OPTION}" in
build) build_image
    ;;
push) push_image
    ;;
run) run_container
    ;;
remove) remove_container
    ;;
*) show_help
    ;;
esac
