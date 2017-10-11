#!/usr/bin/env bash

set -eo pipefail

knife_rb=${knife_rb:=~/lambda.rb}
chef_key=${chef_key:=~/lambda.pem}

sudo yum -y update
sudo yum -y groupinstall "Development Tools"

virtualenv /tmp/pychef
source /tmp/pychef/bin/activate
pip install pychef

mkdir -p /tmp/deregister_chef_node/.chef
cp -r /tmp/pychef/lib/python2.7/site-packages/* /tmp/deregister_chef_node
cp -r /tmp/pychef/lib64/python2.7/site-packages/* /tmp/deregister_chef_node
cp $chef_key /tmp/deregister_chef_node/.chef/lambda.pem
cp $knife_rb /tmp/deregister_chef_node/.chef/knife.rb

pushd /tmp/deregister_chef_node
chmod -R 755 .chef
chmod 644 .chef/lambda.pem
zip -r ../deregister_chef_node.zip * .chef
popd

cp /tmp/deregister_chef_node.zip .
rm -rf /tmp/deregister_chef_node /tmp/deregister_chef_node.zip /tmp/pychef $knife_rb $chef_key
