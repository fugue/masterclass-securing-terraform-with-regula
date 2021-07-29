# 4: IaC Pre-Commit Checks

How do we provide feedback to developers on their IaC templates really early?

**Pre-commit hooks** with Git are a great way to do this. Let's try it out. We
recommend using the Python [pre-commit](https://pre-commit.com/) package to make
this super easy.

The idea is this: 

## Pre-Commit Setup

There are a few options, including pip:

```
pip install pre-commit
```

And homebrew:

```
brew install pre-commit
```

Add a `.pre-commit-config.yaml` to your Git repository:

```yaml
repos:
  - repo: local
    hooks:
    - id: regula-
      name: Regula IaC Checks
      entry: regula run -f table -i .waivers.rego
      language: system
      files: .*(tf)
```

Install the hooks:

```bash
pre-commit install
```

## Try it Out

Run against all files to test it:

```bash
pre-commit run --all-files
```

Or make a change to some Terraform files and make some commits! You'll see
feedback when you run `git commit`. Regula will run against changed IaC templates only, thanks to how pre-commit hooks work.

The [example.tf](./example.tf) file here has an insecure assume role policy
commented out. Uncomment that and try to commit the change.

## Summary

Pre-commit hooks with Regula are a great way to catch misconfigurations in IaC
really early in development. Consider having your team adopt this approach in
your IaC Git repositories.
