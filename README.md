# misskey-docker

Docker for Misskey-delta

## How to use

1. Clone `https://github.com/misskey-delta/misskey-docker.git`
2. Setting `/etc/hosts`
3. Build `docker build -t misskey-docker .`
4. Run `docker run -d -p 50000:50000 -p 50001:50001 -p 50010:50010 -p 50011:50011 -p 50012:50012 misskey-docker`
5. Access `http://misskey.local:50000/`

## /etc/hosts

```
# For misskey-docker
127.0.0.1   misskey.local uc-misskey.local admin.misskey.local auth.misskey.local signup.misskey.local signin.misskey.local signout.misskey.local about.misskey.local search.misskey.local help.misskey.local talk.misskey.local share.misskey.local himasaku.misskey.local resources.misskey.local streaming.misskey.local api.misskey.local
```

## License

Release under the MIT License
