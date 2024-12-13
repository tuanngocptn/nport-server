# nport-server

```
sudo certbot certonly --dns-cloudflare --dns-cloudflare-credentials /home/bitnami/.secrets/credentials.ini --server https://acme-v02.api.letsencrypt.org/directory --preferred-challenges dns -d '*.nport.link' -d 'nport.link'
```