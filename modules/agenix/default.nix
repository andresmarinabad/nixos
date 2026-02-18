# Declara aqui los secretos y donde estará el descifrado
{ ... }:
{
  # Solo descifrar con Master Key
  age.identityPaths = [ "/home/andres/.ssh/master" ];

  # PASSWORDS
  age.secrets.pass-andres.file = ./pass-andres.age;
  age.secrets.pass-sara.file = ./pass-sara.age;

  # GITHUB SSH
  age.secrets.github-andres = {
    file = ./github-andres.age;
    path = "/home/andres/.ssh/andres";
    owner = "andres";
    group = "users";
    mode = "600";
  };

  age.secrets.github-aistech = {
    file = ./github-aistech.age;
    path = "/home/andres/.ssh/gandalf";
    owner = "andres";
    group = "users";
    mode = "600";
  };

}
