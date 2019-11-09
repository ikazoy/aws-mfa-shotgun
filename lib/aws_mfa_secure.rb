$:.unshift(File.expand_path("../", __FILE__))
require "aws_mfa_secure/version"
require "rainbow/ext/string"

require "aws_mfa_secure/autoloader"
AwsMfaSecure::Autoloader.setup

module AwsMfaSecure
  class Error < StandardError; end
end

require "#{Dir.pwd}/spec/monkey_patches" if ENV['AWS_MFA_SECURE_TEST']
