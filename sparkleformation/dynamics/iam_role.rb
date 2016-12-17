SparkleFormation.dynamic(:iam_role) do |_name, _config = {}|
  dynamic!(:i_a_m_role, _name).properties do
    assume_role_policy_document do
      version '2012-10-17'
      statement _array(
        -> {
          effect 'Allow'
          principal do
            service _array('lambda.amazonaws.com')
          end
          action _array('sts:AssumeRole')
        }
      )
    end
  path '/'
  end
end