# Hazy Maze

ZKP maze + account abstraction prototype

Generated from https://github.com/privacy-scaling-explorations/zkp-app-boilerplate

## Pre requisites

* [nodejs](https://nodejs.org)
  * Reccomended: [nvm](https://github.com/nvm-sh/nvm)
* [yarn](https://classic.yarnpkg.com)
* [rust](https://www.rust-lang.org/tools/install)

## Getting started

1. Clone the repository
    ```shell
    git clone https://github.com/jacque006/hazy-maze.git
    ```
2. Initialize git submodules
    ```shell
    git submodule init && git submodule update
    ```
3. [Compile & install circom2](https://docs.circom.io/getting-started/installation/), using the [circom submodule](./circom/)
4. Install packages
    ```shell
    yarn
    ```
5. Build: this compiles the circuits and exports artifacts. Then compiles the contracts and generate typescript clients.
    ```shell
    yarn build
    ```
6. Run a demo app using a localhost private network.
    ```shell
    yarn demo
    ```

## Run tests
1. Test contracts
    ```shell
    yarn workspace contracts test
    ```

2. Test your circuits
    ```shell
    yarn workspace circuits test
    ```

3. Test your app
    ```shell
    yarn workspace app test
    ```
