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

# Tear down the stacks
for stack in $(aws cloudformation list-stacks \
 --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE DELETE_FAILED \
 --query 'StackSummaries[?contains(StackName, `'${org}'-'${environment}'-lambda`) == `true`].StackId' \
 --output text); do

  run_if_yes "aws cloudformation delete-stack --stack-name $stack"
done
