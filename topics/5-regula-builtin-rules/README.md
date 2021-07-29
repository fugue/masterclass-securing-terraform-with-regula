# 5: Regula Built-In Rules

You don't need to start from scratch with rules for IaC security. Regula includes
many rules for AWS, Azure, and Google clouds and those run by default.

The Regula built-in rules are listed [here](https://regula.dev/rules.html).

## Rule Packaging

The built-in rules are embedded in the Regula binary when it is built. So there
are no extra steps to make use of them. One binary and you're good to go.

You can easily add your own custom rules on top of those default ones, or
run only your custom ones. You can manage your rules in the same Git repo as
your IaC templates, or in a separate one.

## Running all Rules against all IaC Templates

This is super simple: it's the default 🎉

```bash
regula run
```

This looks for all Terraform HCL and CloudFormation templates in all subdirectories.
It does exclude files that are mentioned in your `.gitignore` however, so that
temporary files aren't evaluated by default.

## Some Important Built-In Rules

 * `FG_R00277` - S3 buckets should not be publicly readable
 * `FG_R00255` - IAM roles with trust relationships should have MFA or external IDs
 * `FG_R00222` - MySQL database server firewall rules should not permit 0.0.0.0
 * `FG_R00154` - Azure storage accounts should deny access from all networks by default
 * `FG_R00412` - Google compute instances should not use the default service account with full access to all Cloud APIs

There are a lot of ways you can go wrong in the cloud. Regula's built-in rules
go a long way to help with this.

## Rule Categories

You need rules covering security issues and misconfigurations in these areas:

 * Encryption (at rest, in transit)
 * Secure login
 * Credential management
 * Public access
 * Availability and redundancy
 * IAM policies and permissions
 * Logging, monitoring, alerting
