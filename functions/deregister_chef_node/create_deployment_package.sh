#!/usr/bin/env bash

knife_rb=${knife_rb:=~/.chef/lambda.rb}
chef_key=${chef_key:=~/.chef/lambda.pem}

virtualenv /tmp/pychef
source /tmp/pychef/bin/activate
pip install pychef

mkdir /tmp/deregister_chef_node
cp -r /tmp/pychef/lib/python2.7/site-packages/* /tmp/deregister_chef_node
cp -r .chef /tmp/deregister_chef_node
cp $chef_key /tmp/deregister_chef_node/.chef/lambda.pem
cp $knife_rb /tmp/deregister_chef_node/.chef/knife.rb
cp deregister_chef_node.py /tmp/deregister_chef_node

pushd /tmp/deregister_chef_node
chmod -R 755 deregister_chef_node.py .chef
chmod 644 .chef/lambda.pem
zip -r ../deregister_chef_node.zip * .chef
popd

cp /tmp/deregister_chef_node.zip .
rm -rf /tmp/deregister_chef_node /tmp/deregister_chef_node.zip /tmp/pychef
