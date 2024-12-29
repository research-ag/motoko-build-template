# Reproducible builds example

This project demonstrates how to achieve reproducible builds for Motoko canisters using Docker. The setup ensures that the same source code always generates the same Wasm module, with a consistent module hash. This is crucial for verifying canisters on the Internet Computer.

## How It Works

The project uses a Docker image that contains the Motoko compiler, mops package manager, and ic-wasm tool. By using a consistent build environment, we ensure that every build produces identical results, which is key to reproducibility.

## Prerequisites

- Docker installed on your machine
- Basic knowledge of the Internet Computer and Wasm modules

## Steps to Reproduce the Build

Follow these steps to build the Wasm module and ensure that the build is reproducible.

### 1. Clone the repository

Start by cloning the example project repository:

```bash
git clone https://github.com/research-ag/reproducible-builds-with-docker.git
cd reproducible-builds-with-docker
```

### 2. Build the Docker image

Using the pre-built remote base image (quicker):

```bash
docker-compose build wasm
```

Building the base image locally (slower):

```bash
docker-compose build base
docker-compose build wasm --build-arg REMOTE=
```

### 3. Build the Wasm module

Run the following command to build the Wasm module:

```bash
docker-compose run --rm wasm
```

After the build completes, the hash of the Wasm module will displayed like this:
```
6c17cb5f5f5bb8f2d09452632b76dbf3be0fd76047d0b6f87f6460c7f88812d6  out/out_Linux_x86_64.wasm
```
The generated Wasm module is available in the file `out/out_Linux_x86_64.wasm`.

### 4. Alternative commands

Alternatively, you can run:

```bash
docker-compose up wasm
docker-compose down
```

The `down` command will remove the docker container, `--rm` is not required.
If in the past you have forgotten to run `docker-compose down` then you can run `docker-compose down --remove-orphans` to remove all old containers.

### 5. Verify a deployed canister

If you see a deployed canister then you can inspect its wasm module for example on `dashboard.internetcomputer.org` or with the `dfx canister --ic info <canister principal>` command.
Then you run the same commands as for building the canister and compare the hash that is printed during the build to the one found on the IC. 

### 6. Modify and re-build

Any of the following will have an impact on the resulting Wasm module hash:

* the `[dependencies]` section in mops.toml
* the files in `src/`
* the file `did/service.did`
* the file `build.sh`

If you modified them and want to re-run the build process then you have to use the commands

```bash
docker-compose run --rm --build wasm
```

or

```bash
docker-compose up wasm --build
docker-compose down
```

Otherwise, without the `--build` option, `docker-compose` will use the previously created image and not take into account your changes.

### 7. Build locally

You can also run `./build.sh` locally to build natively on the host.
You need to have `mops` and `moc` installed on you system.

Note that `build.sh` uses `mops` only for package dependencies. 
It calls `moc` directly, not `moc-wrapper`, hence it does not use the `[toolchain]` section of `mops.toml`.
This means you must have installed the desired version of `moc` in your PATH.

For example, on a Mac you may get the following hash:

```
89fc3271c8019dbcc590abc04ff9cbb58202714385a1bd2116bd67c836828267  out/out_Darwin_arm64.wasm
```

### 8. Integrate into your own repo

You can use this repo as the base for your own project. You can continue to use the same `Dockerfile`, `docker-compose.yml` and `build.sh`. The requirements are:

* There must exist directories `src`, `did` and `out`.
* You can (but don't have to) provide a custom did file `did/service.did` which will get embedded into the Wasm module instead of the one generated by `moc`.
* If your `did` directory is empty, then you have to check the empty file `did/.gitkeep` into your repo so that it is created when checking out the repo with `git`.
* You have to do the same for the `out` directory.  

Note: Technically, it is possible to let docker create the `out` directory. So it would not have to be present in the repo.
In practice, however, this can lead to permission problems.
Since we want to make it as easy as possible for any verifier to repeat the steps we recommend to have the empty `out` directory in the repo.

## Deploy the Wasm module

You can deploy the generated Wasm module to the Internet Computer using the Dfinity SDK. Follow the [official documentation](https://internetcomputer.org/docs/current/developer-docs/developer-tools/cli-tools/cli-reference/dfx-canister#dfx-canister-install) for deployment instructions.
