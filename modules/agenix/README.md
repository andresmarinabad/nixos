## Cifrar secretos

1. Colocate en esta ruta.
2. Define el secreto en `default.nix` y quien puede descifrarlo en `secrets.nix`
3. Cifra el secreto con

```bash
nix run github:ryantm/agenix -- -e <secreto>.age -i ~/.ssh/master
```

[!IMPORTANT]
Recuerda añadir los secretos a stage de git para que flake los detecte

## Passwords

1. Hash de tu password

```bash
mkpasswd -m sha-512
```

2. Cifra el secreto
