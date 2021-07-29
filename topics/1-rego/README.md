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

```javascript
package example

allow = true {              # allow is true if...
    input.role == "admin"   # the user is an admin
}
```

## Run the Example

Try it out using the OPA REPL:

```
opa run example.rego
```

```
OPA 0.28.0 (commit 3fbcd71, built at 2021-04-27T13:51:34Z)

Run 'help' to see a list of commands and check for updates.

> import data.example
> example.allow with input as example.curtis
true
> example.allow with input as example.josh
false
> 
```
