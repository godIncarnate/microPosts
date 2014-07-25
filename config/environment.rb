# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

WillPaginate::ViewHelpers.pagination_options[:previous_label] = '上一页'

WillPaginate::ViewHelpers.pagination_options[:next_label] = '下一页'
