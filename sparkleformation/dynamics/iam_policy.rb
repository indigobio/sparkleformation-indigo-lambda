SparkleFormation.dynamic(:iam_policy) do |_name, _config = {}|
  dynamic!(:i_a_m_policy, _name).properties do
    policy_name _name
    policy_document do
      version '2012-10-17'
      statement _array(
        -> {
          action %w(logs:CreateLogGroup
                    logs:CreateLogStream
                    logs:PutLogEvents)
          resource join!('arn', 'aws', 'logs', '*', '*', '*', :options => { :delimiter => ':'})
          effect 'Allow'
        },
        *_config.fetch(:policy_statements, []).map { |s| s.is_a?(Hash) ? registry!(s.keys.first.to_sym, s.values.first) : registry!(s.to_sym) }
      )
    end
    roles _array(ref!("#{_name}_i_a_m_role".to_sym))
  end

  dynamic!(:i_a_m_policy, _name).depends_on "#{_name}IAMRole"
end