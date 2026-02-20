# Secretos con agenix

Los secretos se cifran con [age](https://github.com/FiloSottile/age) y se gestionan con [agenix](https://github.com/ryantm/agenix). Solo se pueden descifrar con la clave SSH configurada como identidad (en este repo: `~/.ssh/master`).

---

## Añadir un nuevo secreto (comandos completos)

Ejemplo: añadir un secreto llamado `mi-secreto.age`.

### 1. Editar `secrets.nix`

Añade una línea (usa el nombre del archivo `.age`):

```nix
"mi-secreto.age".publicKeys = [ master ];
```

### 2. Editar `default.nix`

- Si solo necesitas el secreto como archivo en el sistema (path por defecto en `/run/age/`):

  ```nix
  age.secrets.mi-secreto.file = ./mi-secreto.age;
  ```

- Si debe ir a una ruta concreta (ej. clave SSH, WiFi):

  ```nix
  age.secrets.mi-secreto = {
    file = ./mi-secreto.age;
    path = "/ruta/destino";
    owner = "andres";
    group = "users";
    mode = "600";
  };
  ```

### 3. Crear el archivo cifrado

**Desde la raíz del módulo agenix**:

```bash
cd modules/agenix

# Escribir el secreto a mano
nix run github:ryantm/agenix -- -e mi-secreto.age
```

### 4. Añadir al git para que el flake lo vea

```bash
git add modules/agenix/mi-secreto.age
```

### 5. Usar el secreto en la config NixOS

Por ejemplo: `config.age.secrets.mi-secreto.path`

---

## Crear un password de usuario (login NixOS)

Comandos en orden:

```bash
# 1. Generar hash de la contraseña (te la pedirá)
mkpasswd -m sha-512

# 2. Ir al modulo
cd modules/agenix

# 3. Añadir en secrets.nix: "pass-usuario.age".publicKeys = [ master ];
# 4. Añadir en default.nix: age.secrets.pass-usuario.file = ./pass-usuario.age;

# 5. Crear el secreto pegando SOLO la línea del hash que salió en el paso 1
nix run github:ryantm/agenix -- -e pass-usuario.age

# 6. Añadir al git
git add modules/agenix/pass-usuario.age
```

En la config del usuario: `hashedPasswordFile = config.age.secrets.pass-usuario.path;`

---

## Cambiar la passphrase de la clave maestra

### Qué es la passphrase

La **passphrase** es la contraseña que desbloquea tu clave privada `~/.ssh/master`. No está en el repo: solo la tienes tú. Los archivos `.age` están cifrados con la **clave pública**; para descifrarlos el sistema usa la **clave privada**, y para usar la clave privada te pide la passphrase (si está configurada).

### Implicaciones de cambiar la passphrase

- **No hace falta tocar** `secrets.nix` ni los archivos `.age`.
- Los secretos siguen cifrados para la misma clave pública; solo cambia la contraseña que **tú** pones cuando se usa la clave privada.

### Cuándo se usa la passphrase

- Al hacer **`nixos-rebuild switch`** (o boot), si NixOS necesita descifrar secretos y usa `~/.ssh/master`, puede pedir la passphrase (depende de si el agente SSH tiene la clave cargada).
- Si usas **ssh-agent**: al hacer `ssh-add ~/.ssh/master` te pide la passphrase una vez; después ya no hasta que reinicies el agente o la máquina.

### Comando para cambiar solo la passphrase

```bash
ssh-keygen -p -f ~/.ssh/master
```

Te pedirá la passphrase actual y luego la nueva. No hay que re-cifrar nada.

---

## Cambiar la clave maestra (nueva clave SSH) y re-cifrar

Si sustituyes `~/.ssh/master` por **otra clave** (otro par de claves), los `.age` actuales están cifrados para la **clave pública antigua**, así que hay que **re-cifrarlos** para la clave pública nueva. Si no, al hacer rebuild no se podrán descifrar.

### 1. Generar la nueva clave

```bash
# No sobrescribas la vieja todavía; usa otro nombre
ssh-keygen -t ed25519 -C "master" -f ~/.ssh/master_new
```

Obtén la clave pública para el siguiente paso:

```bash
cat ~/.ssh/master_new.pub
```

### 2. Actualizar `secrets.nix` con la nueva clave pública

Sustituye la variable `master` por la nueva clave (la línea que salió de `cat ~/.ssh/master_new.pub`):

```nix
master = "ssh-ed25519 AAAA... tu_nueva_clave ...";
```

**No quites ni renombres la clave privada antigua** hasta terminar de re-cifrar: hace falta para poder descifrar cada `.age` y volver a cifrarlo.

### 3. Re-cifrar todos los secretos

Tienes que hacer **descifrar → cifrar** para **cada** archivo `.age` que tengas en `secrets.nix`. La identidad que use agenix al descifrar debe ser la **clave antigua** (la que sigue en `~/.ssh/master`). Al cifrar, agenix usará las claves de `secrets.nix` (ya la nueva).

**Desde la raíz del módulo agenix** (`modules/agenix`):

Para cada secreto, ejecuta estos dos comandos (sustituye `NOMBRE` por el nombre del archivo sin `.age` y el contenido que salga del `-d` pégalo en el `echo -n "..."` del `-e`):

```bash
nix run github:ryantm/agenix -- -d NOMBRE.age
# Copia lo que salga en pantalla, luego:
echo -n "PEGA_AQUI_EL_CONTENIDO" | nix run github:ryantm/agenix -- -e modules/agenix/pass-andres.age
```

Si en `secrets.nix` tienes más entradas (p. ej. otro `wifi-*.age`), repite el mismo par de comandos para cada una.

### 4. Sustituir la clave antigua por la nueva

Cuando **todos** los `.age` estén re-cifrados:

```bash
mv ~/.ssh/master ~/.ssh/master_old
mv ~/.ssh/master_new ~/.ssh/master
mv ~/.ssh/master_new.pub ~/.ssh/master.pub
```

Si en tu config NixOS usas `age.identityPaths = [ "/home/andres/.ssh/master" ]`, no hace falta cambiarla: el path sigue siendo `~/.ssh/master`.

### 5. Comprobar

```bash
sudo nixos-rebuild switch --flake .#TU_HOST
```

Si no hay errores de descifrado y el login / WiFi / SSH funcionan, ya estás usando la nueva clave. Luego puedes borrar la vieja: `rm ~/.ssh/master_old ~/.ssh/master_old.pub` (guárdala por si acaso hasta estar seguro).

---

## Resumen rápido de comandos

| Acción                     | Comando                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------- |
| Crear/sobrescribir secreto | `echo -n "contenido" \| nix run github:ryantm/agenix -- -e modules/agenix/NOMBRE.age` |
| Descifrar (ver contenido)  | `nix run github:ryantm/agenix -- -d modules/agenix/NOMBRE.age`                        |
| Cambiar solo passphrase    | `ssh-keygen -p -f ~/.ssh/master`                                                      |
| Hash para password NixOS   | `mkpasswd -m sha-512`                                                                 |

Todos los comandos de agenix hay que ejecutarlos desde la **raíz del repo** (donde está el flake).
