## Cifrar secretos

1. Entra en modules/agenix
2. Define el secreto en `default.nix` y configura quién puede descifrarlo en `secrets.nix`
3. Cifra el secreto:

```bash
nix run github:ryantm/agenix -- -e <secreto>.age
```

Recuerda añadir los secretos al stage de git para que flake los detecte

## Passwords

1. Hash de tu password

```bash
mkpasswd -m sha-512
```

2. Cifra el secreto
