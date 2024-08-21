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