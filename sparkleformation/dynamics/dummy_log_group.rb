SparkleFormation.dynamic(:dummy_log_group) do |_name, _config = {}|

  # Totally a hack.  https://github.com/serverless/serverless/pull/1934

  dynamic!(:logs_log_group, _name).properties do
    log_group_name "#{_name}_dummy_do_not_use"
    retention_in_days '1'
  end
  dynamic!(:logs_log_group, _name).depends_on "#{_name}IAMPolicy"
end