# 3: Regula and Terraform

Writing Rego policies against Terraform without a framework to work within gets
complicated quickly. 

Issues we have to consider:

 * Need a consistent API for policies
 * Need a standard way to declare policy metadata (e.g. Severity)
 * Need an easy way to look up resources by type
 * Want our policies to work for **both** HCL and Plans
 * Don't want to have to understand the details of Terraform Plan JSON
 * Need a standardized output format or report
 * How do we process Terraform modules, or groups of tf files?
 * Need our policies to work for IaC and Runtime resources

This is what Regula is built to do. It provides tools and a well-defined approach
for writing **Rules** (policies) against resources, and provides a number of easy to use output formats.

## Example Rule

This example Regula rule works for both HCL and Plans.

```python
package example

__rego__metadoc__ := {
	"id": "MASTERCLASS_01",
	"custom": {"severity": "Medium"},
	"title": "Users must have a department tag set",
}

resource_type := "aws_iam_user"

default allow = false

allow {
	input.tags.department
}
```

## Try it Out

Run the rule with Regula as follows. The `-u` says _only run user provided rules_.

```bash
regula run -u -i example.rego
```

You should see output like:

```
No problems found. Nothing can stop you now.
```

And try the table formatted output:

```bash
regula run -u -i example.rego -f table
```
