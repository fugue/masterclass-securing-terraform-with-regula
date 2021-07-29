# 6: Regula Usage

We aim to make getting started with Regula trivial, whether it's on your laptop
or in CI/CD.

On the [Getting Started](https://regula.dev/getting-started.html) page you can
see we have binaries for all major platforms and a Docker image.

Run Regula with the `-h` option to get loads of tips.

## Via Docker with a Mounted Volume

If you have docker, you can really just run one command:

```bash
docker run --rm -t \
    -v $(pwd):/workspace \
    --workdir /workspace \
    fugue/regula:v1.0.0 run
```

## Install Regula in a CircleCI Job

Here's an example of using `curl` to download the latest Regula release from Github.

```yaml
  install_regula:
    steps:
      - run:
          name: Install Regula
          command: |
            archive="regula_1.0.0_Linux_x86_64.tar.gz"
            asset_url="https://github.com/fugue/regula/releases/download/v1.0.0/${archive}"
            curl -sLJO -H 'Accept:application/octet-stream' "${asset_url}"
            tar -xvzf ${archive}
            chmod +x regula
            sudo mv regula /usr/local/bin/regula
```
