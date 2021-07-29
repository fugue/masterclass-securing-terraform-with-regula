# 2: Rego and Terraform

We just saw that Rego is used to evaluate policies against JSON. How does this
apply to Terraform?

## Terraform HCL

> This low-level syntax of the Terraform language is defined in terms of a syntax called HCL

[Terraform Docs](https://www.terraform.io/docs/language/syntax/configuration.html)

```hcl
resource "aws_iam_user" "joe" {
  name = "joe"
  path = "/"
  tags = {
    department = "engineering"
  }
}

resource "aws_iam_access_key" "user-key" {
  user = aws_iam_user.joe.name
}
```

Convert HCL to JSON with Regula:

```bash
regula show input example.tf
```

Minimal processing with JQ to unwrap:

```bash
regula show input example.tf | jq '.[0].content.resources'
```

Output:

```json
{
  "aws_iam_access_key.user-key": {
    "_filepath": "example.tf",
    "_provider": "aws",
    "_type": "aws_iam_access_key",
    "id": "aws_iam_access_key.user-key",
    "user": "joe"
  },
  "aws_iam_user.joe": {
    "_filepath": "example.tf",
    "_provider": "aws",
    "_type": "aws_iam_user",
    "id": "aws_iam_user.joe",
    "name": "joe",
    "path": "/",
    "tags": {
      "department": "engineering"
    }
  }
}
```

**Now we can run Rego against our HCL!**

```python
package example

default allow = true

allow = true {
    resource = input[_]
    resource._type == "aws_iam_user"
    count(resource.tags) > 0
}
```

This low-level approach gets complicated quickly though. Regula can help.

## Terraform Plan

> Terraform can output a machine-readable JSON representation of a plan file's changes.

[Terraform Docs](https://www.terraform.io/docs/internals/json-format.html)

```bash
terraform init
terraform plan -out=example.plan
terraform show -json example.plan > example-plan.json
```

Now we can run Rego against our Terraform plan!

Oh... but this plan JSON is super complicated. Regula can help.

