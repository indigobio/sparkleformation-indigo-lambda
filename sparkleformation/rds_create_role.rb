SparkleFormation.new(:rds_create_role).load(:base).overrides do
  description <<EOF
Creates an AWS Lambda that creates non-privileged roles in newly-created RDS instances
EOF

  dynamic!(:iam_policy, 'RdsCreateRole',
           :policy_statements => [ :describe_rds_db_instances, :create_ec2_network_interface ]
          )

  dynamic!(:iam_role, 'RdsCreateRole')

  dynamic!(:dummy_log_group, 'RdsCreateRole')

  dynamic!(:sns_topic, "#{ENV['org']}_#{ENV['environment']}_rds_create_role",
           :subscriber => 'RdsCreateRoleLambdaFunction',
           :protocol => 'lambda'
          )

  dynamic!(:permission, 'RdsCreateRole',
           :sns_topic => "#{ENV['org'].capitalize}#{ENV['environment'].capitalize}RdsCreateRoleSNSTopic",
           :lambda => 'RdsCreateRoleLambdaFunction'
          )

  dynamic!(:function, 'RdsCreateRole',
           :timeout => '30',
           :bucket => registry!(:my_s3_bucket, 'lambda'),
           :key => 'rds_create_role/rds_create_role.zip',
           :handler => 'rds_create_role.lambda_handler',
           :role => 'RdsCreateRoleIAMRole',
           :security_groups => _array(registry!(:my_security_group_id, 'private_sg')),
           :subnet_ids => registry!(:my_private_subnet_ids)
          )
end
