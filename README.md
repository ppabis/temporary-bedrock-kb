Setting region
--------------
In some places there might be a leftover from `us-west-2`. Ideally just search
for all the occurrences in this repo and replace it with your region.
Definitely you have to change them in `main.tf` and in `vars_step_functions.tf`.

Preparing Lambda libraries
--------------------------
Before you apply the infrastructure, you have to install first some Python
packages. On Linux you should be able to do it directly using `--target`. On Mac
or Windows, you can use Docker.

```bash
# On Linux
$ pip install opensearch-py requests-aws4auth --target lambda

# On Mac
$ docker run --rm -it\
 -v $(pwd)/lambda:/tmp/pip \
 -u $(id -u) \
 python:3.12 \
 pip install opensearch-py requests-aws4auth \
 --target /tmp/pip
```