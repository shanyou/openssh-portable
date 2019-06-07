How to use openssh in docker
===

## Running
It simply needs to be run with port 22 open
```bash
docker run -d --name ssh-server -p 22 yunlu/openssh:dev
```
It only takes key auth so you can either copy your public key
``` bash
cat ~/.ssh/id_rsa.pub | docker exec -i ssh-server /bin/bash -c "cat >> /root/.ssh/authorized_keys"
```