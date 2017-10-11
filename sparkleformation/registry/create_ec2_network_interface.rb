SfnRegistry.register(:create_ec2_network_interface) do
  { 'Action' => %w(ec2:AttachNetworkInterface
                   ec2:CreateNetworkInterface
                   ec2:DeleteNetworkInterface
                   ec2:DescribeNetworkInterfaces
                   ec2:DescribeNetworkInterfaceAttribute
                   ec2:DetachNetworkInterface
                   ec2:ModifyNetworkInterfaceAttribute
                   ec2:ResetNetworkInterfaceAttribute),
    'Resource' => %w( * ),
    'Effect' => 'Allow'
  }
end
