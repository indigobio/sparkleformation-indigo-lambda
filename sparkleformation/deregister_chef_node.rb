SparkleFormation.new(:deregister_chef_node).load(:base, :git_rev_outputs).overrides do
  description <<EOF
Creates an AWS Lambda that deregisters Chef nodes upon instance termination in an auto-scaling group.
EOF

  dynamic!(:iam_policy, 'DeregisterChefNode')

  dynamic!(:iam_role, 'DeregisterChefNode')

  dynamic!(:dummy_log_group, 'DeregisterChefNode')

  dynamic!(:sns_topic,  "#{ENV['org']}_#{ENV['environment']}_deregister_chef_node",
           :subscriber => 'DeregisterChefNodeLambdaFunction',
           :protocol => 'lambda'
          )

  dynamic!(:permission, 'DeregisterChefNode',
           :sns_topic => "#{ENV['org'].capitalize}#{ENV['environment'].capitalize}DeregisterChefNodeSNSTopic",
           :lambda => 'DeregisterChefNodeLambdaFunction'
          )

  dynamic!(:function, 'DeregisterChefNode',
           :timeout => '30',
           :bucket => registry!(:my_s3_bucket, 'lambda'),
           :key => 'deregister_chef_node/deregister_chef_node.zip',
           :handler => 'deregister_chef_node.lambda_handler',
           :role => 'DeregisterChefNodeIAMRole'
          )
end
