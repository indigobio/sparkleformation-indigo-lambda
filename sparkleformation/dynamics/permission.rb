SparkleFormation.dynamic(:permission) do |_name, _config = {}|

  dynamic!(:lambda_permission, _name).properties do
    action 'lambda:InvokeFunction'
    principal 'sns.amazonaws.com'
    source_arn ref!(_config[:sns_topic])
    function_name attr!(_config[:lambda], :arn)
  end
end