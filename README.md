# AWS MFA Secure

[![Gem Version](https://badge.fury.io/rb/aws-mfa-secure.png)](http://badge.fury.io/rb/aws-mfa-secure)

Surprisingly, the [aws cli](https://docs.aws.amazon.com/cli/latest/reference/) does not yet support MFA for normal IAM users. See: [boto/botocore/pull/1399](https://github.com/boto/botocore/pull/1399)  The aws-mfa-secure tool decorates the AWS CLI or API to handle MFA authentication.  The MFA prompt only activates if `mfa_serial` is configured.

## Installation

    gem install aws-mfa-secure

Prerequisite: The [AWS CLI](https://docs.aws.amazon.com/cli/latest/reference/) is required. You can install the AWS CLI via pip.

    pip install awscli --upgrade --user

## Usage

**Summary**:

1. Configure `~/.aws/credentials` with `mfa_serial`
2. Set up bash alias
3. Use aws cli like normal

### Configure ~/.aws/credentials with mfa_serial

Set up `mfa_serial` in credentials file for the profile section that requires it. Example:

~/.aws/credentials:

    [mfa]
    aws_access_key_id = BKCAXZ6ODJLQ1EXAMPLE
    aws_secret_access_key = ABCDl4hXikfOHTvNqFAnb2Ea62bUuu/eUEXAMPLE
    mfa_serial = arn:aws:iam::112233445566:mfa/MFAUser

Note: AWS already supports `mfa_serial` assumed roles: [AWS Configuration and Credential File Settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html).  The aws-mfa-secure tool does not decorate for assumed roles and lets the AWS CLI or SDK handle it.  The aws-mfa-secure tool adds support for standard IAM users. See: [boto/botocore/pull/1399](https://github.com/boto/botocore/pull/1399)

### Set up bash alias

    alias aws="aws-mfa-secure session"

You may want to add the alias to your `~/.bash_profile`

Autocompletion still works with the alias.

### Use aws cli like normal

Call `aws` command like you usually would:

    aws s3 ls

### Example with Output

    $ export AWS_PROFILE=mfa
    $ aws s3 ls
    Please provide your MFA code: 751888
    2019-09-21 15:53:34 my-example-test-bucket
    $ aws s3 ls
    2019-09-21 15:53:34 my-example-test-bucket
    $

Expiration: You get prompted for the MFA token once, and the MFA secure session lasts for 12 hours. You can override the default expiration time with `AWS_MFA_TTL`. For example, `AWS_MFA_TTL=3600` means the session expires in 1 hour instead.

## Calling Directly

You can also call `aws-mfa-secure session` directly.

    aws-mfa-secure session --version
    aws-mfa-secure session s3 ls

The arguments of `aws-mfa-secure session` are delegated to the `aws` command.  So:

    aws-mfa-secure session s3 ls

Is the same as:

    aws s3 ls

Except `aws-mfa-secure session` will use the temporary session environment `AWS_*` variables values.

## Exports

You can also generate the exports script.

    $ aws-mfa-secure exports
    Please provide your MFA code: 147280
    export AWS_ACCESS_KEY_ID=ASIAXZ6ODJLBCEXAMPLE
    export AWS_SECRET_ACCESS_KEY=HgYHvNxacSsFSwls1FO9RoF5+tvYCFIABEXAMPLE
    export AWS_SESSION_TOKEN=IQoJb3JpZ2luX2VjEJ3//////////wEaCXVzLWVhc3QtMSJGMEQCIGnuGzUr8aszNWMFlFXQvFVhIA6aGdx3DskqY1JaIZWVAiANfE3xA79vIMVTqLnds4F2LpDy/qUeNRr7e9g9VQoS9SqyAQi2//////////8BEAEaDDUzNjc2NjI3MDE3NyIMgDgauwgJ4FIOMRV+KoYBRKR/MnKFB9/Q0Isc6D8gpG404xGJWqStNfGS0sHNsB5vVP/ccaAj4MG54p0Pl+V0LuIMXy345ua/bxxQFDWqhG0ORsXFEOo3iD1IQ+YA/yougAUl/0hbyvK3Jnf3NEHDejdL95iFCluJhoR0zFlDv7GwwBSXLUxS9K96/vgA0MmgK9a7kaAwoYiZ7gU63wHVDNYa1myqIP16Mi6KZ2zm9inMofixNN1ea3JMyRW+chWW8kdjjW4R3MFecpwoIayE7g3QLanmjE3jzrlxjIJWnl8tiipV+jassiSdlxLL2j1IIFH2pNEqrn4hkHG5t7OG+qZCTl8AnQ4W5wusmBoSIavr5w0dOdyx2mdsBMFtO82ZXvHSryY1gbIM9JyUd7dJ9h/mkfGL2p0n0R/lya8s9j8P8/8if+2uQcF+/BGDxojJ67kYXgstgfLjM5j8pZgyYj6YUFyTpyiOkllbPk/AjyxJY1svxW25wbNO+c13
    $

You can eval it to set the environment variables in one go. Note, the MFA code prompt is written to standard error so it won't affect the eval.

    $ eval `aws-mfa-secure exports`

If you're using the `aws-mfa-secure exports` command, the `aws-mfa-secure unsets` command is useful to unset the `AWS_*` env variables quickly.  For more info: `aws-mfa-secure unsets -h`.

## AWS Extension

You can also use `aws-mfa-secure` to add MFA support to Ruby libraries. Do so by requiring the `aws_mfa_secure/ext/aws`.

```ruby
require "aws_mfa_secure/ext/aws" # add MFA support
```

This patches the aws-sdk-ruby library and adds MFA support.

## Setting MFA Info with Env Variables

You can also set the MFA info with env variables. They take the highest precedence and override what's in `~/.aws/credentials`. Example:

    AWS_MFA_TOKEN=112233 arn:aws:iam::112233445566:mfa/MFAUser aws s3 ls

## How It Works

docs: [How It Works](docs/how-it-works.md)

## Related

You may also be interested in [tongueroo/aws-rotate](https://github.com/tongueroo/aws-rotate). It's an easy way to rotate all your AWS keys in your `~/.aws/credentials`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
