#!/bin/bash -e

run_if_yes () {
  cmd=$1
  echo -n "$cmd [Y/n]? "
  read response
  case $response in
    Y|y)
      eval $cmd
    ;;
    *)
     echo "skipping"
    ;;
  esac
}

del_stack () {
  stack=$1
  run_if_yes "aws cloudformation delete-stack --stack-name $stack"
  echo -n "Waiting for resource deletion"
  while [ "$(aws cloudformation describe-stacks --stack-name $stack --query 'Stacks[].StackStatus' --output text)" == "DELETE_IN_PROGRESS" ]; do
    echo -n .
    sleep 1
  done
  echo
  if [ "$(aws cloudformation describe-stacks --stack-name $stack --query 'Stacks[].StackStatus' --output text)" == "DELETE_FAILED" ]; then
    echo "$stack failed to delete"
    exit 1
  fi
}

# Tear down the stacks
for stack in $(aws cloudformation list-stacks \
 --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE DELETE_FAILED \
 --query 'StackSummaries[?contains(StackName, `'${org}'-'${environment}'-lambda`) == `true`].StackId' \
 --output text); do

  del_stack $stack
done
