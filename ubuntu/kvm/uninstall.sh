#! /bin/bash

name=$1
if [ -z $name ]; then
        echo "Input name as 1st parameter"
        exit -1
fi

virsh destroy $name
virsh undefine --remove-all-storage $name
