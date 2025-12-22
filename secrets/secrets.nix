let
  master-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAYu20X1SJKhxj92DMkZomM58gaiUzF9KIlRX0tKZhVc";

  andresmarinabad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBoTm8fRXMC50bZwcKxcHRUkauGPfnksKNm3g6zudZn2";
  gandalf-aistech = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHAV+VlsjUxS8JMDzaiIunoV+KqsSPGL2Qs23xnHpfcR";
  users = [ andresmarinabad gandalf-aistech ];

in
{
  "secret_andresmarinabad_ssh_key.age".publicKeys = [ master-key ] ++ users;
  "secret_gandalf_ssh_key.age".publicKeys = [ master-key ] ++ users;
}
