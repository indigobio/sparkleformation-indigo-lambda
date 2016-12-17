SparkleFormation.dynamic(:function) do |_name, _config = {}|

  parameters("#{_name}_code_key".to_sym) do
    type 'String'
    default _config.fetch(:key, "#{_name}/#{_name}.zip")
    allowed_pattern "[\\x20-\\x7E]*"
    description 'S3 key (path) of the zip file containing the deployment package'
    constraint_description 'can only contain ASCII characters'
  end

  parameters("#{_name}_timeout".to_sym) do
    type 'Number'
    min_value 5
    default _config.fetch(:timeout, 120)
    description 'Timeout (in seconds) for the lambda function'
  end

  parameters("#{_name}_memory_size".to_sym) do
    type 'Number'
    min_value 128
    default _config.fetch(:memory_size, 128)
    description 'Memory (in MB) for the lambda function'
  end

  parameters("#{_name}_description".to_sym) do
    type 'String'
    default _name
    allowed_pattern "[\\x20-\\x7E]*"
    description 'Lambda description'
    constraint_description 'can only contain ASCII characters'
  end

  parameters("#{_name}_handler".to_sym) do
    type 'String'
    default _config.fetch(:handler, "#{_name}.lamdba_handler")
    allowed_pattern "[\\x20-\\x7E]*"
    description 'Lambda handler function name'
    constraint_description 'can only contain ASCII characters'
  end

  dynamic!(:lambda_function, _name).properties do
    code do
      s3_bucket _config[:bucket]
      s3_key ref!("#{_name}_code_key".to_sym)
    end
    description ref!("#{_name}_description".to_sym)
    handler ref!("#{_name}_handler".to_sym)
    memory_size ref!("#{_name}_memory_size".to_sym)
    role attr!(_config[:role], :arn)
    runtime _config.fetch(:runtime, 'python2.7')
    timeout ref!("#{_name}_timeout".to_sym)
    if _config.has_key?(:security_groups) and _config.has_key?(:subnet_ids)
      vpc_config do
        security_group_ids _config[:security_groups]
        subnet_ids _config[:subnet_ids]
      end
    end
  end

  # Totally a hack.  https://github.com/serverless/serverless/pull/1934
  dynamic!(:lambda_function, _name).depends_on "#{_name}LogsLogGroup"
end