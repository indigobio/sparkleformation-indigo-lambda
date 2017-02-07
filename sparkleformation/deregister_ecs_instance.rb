SparkleFormation.new(:deregister_ecs_instance).load(:base).overrides do
  description <<EOF
Creates an AWS Lambda that deregisters ECS instances upon instance termination in an auto-scaling group
EOF

  dynamic!(:iam_policy, 'DeregisterECSInstance',
           :policy_statements => [ :list_ecs_clusters_and_members, :deregister_ecs_cluster_member ]
          )

  dynamic!(:iam_role, 'DeregisterECSInstance')

  dynamic!(:dummy_log_group, 'DeregisterECSInstance')

  dynamic!(:sns_topic, "#{ENV['org']}_#{ENV['environment']}_deregister_e_c_s_instance",
           :subscriber => 'DeregisterECSInstanceLambdaFunction',
           :protocol => 'lambda'
          )

  dynamic!(:permission, 'DeregisterECSInstace',
           :sns_topic => "#{ENV['org'].capitalize}#{ENV['environment'].capitalize}DeregisterECSInstanceSNSTopic",
           :lambda => 'DeregisterECSInstanceLambdaFunction'
          )

  dynamic!(:function,  'DeregisterECSInstance',
           :timeout => '30',
           :bucket => registry!(:my_s3_bucket, 'lambda'),
           :key => 'deregister_ecs_instance/deregister_ecs_instance.zip',
           :handler => 'deregister_ecs_instance.lambda_handler',
           :role => 'DeregisterECSInstanceIAMRole'
          )
end
