# ruby-server-starter-test

## Basic instruction

### Build

```console
make
```

### Run container

```console
docker run --rm -it --name rss --privileged rss-app:latest -d
```

### Stop container

systemd is running

```console
docker kill rss
```

### Jump into container

```console
docker exec -it rss /bin/bash
```

### Test sinatra pp

Inside the container

```console
for p in `seq 10080 10083`;do curl http://localhost:$p/;done
```

## Reloading tests

```console
# Jump in to the container
docker exec -it rss /bin/bash

# Responds this time
for p in `seq 10080 10083`;do curl http://localhost:$p/;done

# Reload app via start_server
systemctl reload app@*
sleep 5
systemctl status app@*

# Only non-patched puma5 (port 10081) fails
for p in `seq 10080 10083`;do curl http://localhost:$p/;done
# and socket disappears
ls -l /usr/local/app*/log/
```
