# nport-server

```
chmod 600 /home/bitnami/.secrets/credentials.in
```

```
sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials /home/ubuntu/.secrets/credentials.ini --server https://acme-v02.api.letsencrypt.org/directory --preferred-challenges dns -d '*.nport.link' -d 'nport.link'
```

```
PATH=/opt/node/bin:$PATH
```