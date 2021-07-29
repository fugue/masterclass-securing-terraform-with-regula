package rules.example

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
