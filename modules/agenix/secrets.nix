# Quien puede descifrar el secreto
let
  master = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINUSCff7KgC/9Dttohkdp/R2SG0NS8q0wyMjwLd9HNxD"; # Bitwarden
in
{
  "pass-andres.age".publicKeys = [ master ];
  "pass-gandalf.age".publicKeys = [ master ];
  "pass-sara.age".publicKeys = [ master ];
  "github-andres.age".publicKeys = [ master ];
  "github-aistech.age".publicKeys = [ master ];
}
