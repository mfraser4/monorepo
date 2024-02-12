# Monorepo

## Overview

This repository conveniently contains a collection of projects, prototypes, and
packages. The directories are organized by domain.

## Setup

There are Git submodules within this repository that leverage Git LFS. Be sure
to run the following setup script:

```bash
git lfs install
```

Then clone this repository, recursively including the Git submodules:

```bash
git clone --recursive https://github.com/mfraser4/monorepo.git
```
