SfnRegistry.register(:create_ec2_network_interface) do
  { 'Action' => %w(ec2:CreateNetworkInterface ec2:DeleteNetworkInterface ec2:DescribeNetworkInterfaces),
    'Resource' => %w( * ),
    'Effect' => 'Allow'
  }
end
