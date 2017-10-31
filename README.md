# Bash Scripts #
This repo provides some useful scripts for developers who uses unix-like environment.

## Important Notes ##
Some of the scripts require inputs from stdin. So using following piping command combining with curl will not be available.

```bash
curl **script** | bash
```

In such cases, please use the following stream substitution command instead.

```bash
bash <(curl **script**) 
```

### Scripts that require stream substitution syntax
centos/centos-install.sh
centos/centos-install-php.sh
