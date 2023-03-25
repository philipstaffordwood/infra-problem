# NOTES

## Prereqs

### Java

- [ ] Version? - going with openJDK 17

Install with:

```bash
sudo apt update
sudo apt install openjdk-17-jdk
```

Verify using `java --version`

```
cedar@cedar:/code/melio-consulting/infra-problem$ java --version
openjdk 17.0.6 2023-01-17
OpenJDK Runtime Environment (build 17.0.6+10-Ubuntu-0ubuntu120.04.1)
OpenJDK 64-Bit Server VM (build 17.0.6+10-Ubuntu-0ubuntu120.04.1, mixed mode, sharing)
```

### Leiningen

From https://leiningen.org/

```bash
wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein
chmod a+x lein 
./lein 
sudo mv lein /usr/local/bin/
lein
```