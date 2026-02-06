# Quien puede descifrar el secreto
let
  andres = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICqImXgnyR1mINurbZY0xV5EJmKUQWGv6BxQihpsgxiD andres.marin.abad+git@gmail.com"; # /home/andres/.ssh/andres.pub
  sistema = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfvCyUc8mSkjGjH5hywMni0ciTo6PseFheOj6/pF9vy root@nixos"; # /etc/ssh/ssh_host_ed25519_key.pub)
in
{
  "pass-andres.age".publicKeys = [ andres sistema ];
  "pass-gandalf.age".publicKeys = [ andres sistema ];
  "pass-sara.age".publicKeys = [ andres sistema ];
  "github-andres.age".publicKeys = [ andres sistema ];
}