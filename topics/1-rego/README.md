# 1: The Rego Language

> OPA policies are expressed in a high-level declarative language called Rego. Rego (pronounced “ray-go”) is purpose-built for expressing policies over complex hierarchical data structures.

[OPA documentation](https://www.openpolicyagent.org/docs/latest/#rego)

## Input

We process an `input` JSON document using Rego. This is _arbitrary JSON_.

```json
{ "name": "Curtis", "role": "admin" }
```

## Policy

> OPA generates policy decisions by evaluating the query input and against policies and data.

```python
package example

allow = true {              # allow is true if...
    input.role == "admin"   # the user is an admin
}
```

## Example

A simple "allow" policy for users in Rego.

```python
package example

default allow = false       # by default, don't allow anyone

allow = true {              # allow is true if...
    input.role == "admin"   # the user is an admin
}

curtis = { "name": "Curtis", "role": "admin" }

josh = { "name": "Josh", "role": "foo" }
```

## Run the Example

Try it out using the OPA REPL:

```bash
opa run example.rego
```

```python
> import data.example
> example.allow with input as example.curtis
true
> example.allow with input as example.josh
false
> 
```
