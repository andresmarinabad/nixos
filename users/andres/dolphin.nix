{ ... }:

{
  # Dolphin configuration
  xdg.configFile."dolphinrc".text = ''
    [General]
    ConfirmClosingMultipleTabs=false
    OpenExternallyCalledFolderInNewTab=true
    RememberOpenedTabs=false
    ShowFullPath=true
    ShowFullPathInTitlebar=true
    ShowStatusBar=FullWidth

    [MainWindow]
    MenuBar=Disabled

    [Notification Messages]
    ConfirmOpenManyFolders=false
    ConfirmOpenManyTerminals=false
    warnAboutRisksBeforeActingAsAdmin=false

    [PreviewSettings]
    Plugins=appimagethumbnail,audiothumbnail,blenderthumbnail,comicbookthumbnail,cursorthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,textthumbnail,ffmpegthumbs

  '';

  # Folder icons
  home.file."Desktop/.directory".text = ''
    [Desktop Entry]
    Icon=folder-cyan-desktop
  '';

  home.file."Documents/.directory".text = ''
    [Desktop Entry]
    Icon=folder-black-documents
  '';

  home.file."Downloads/.directory".text = ''
    [Desktop Entry]
    Icon=folder-violet-downloads
  '';

  home.file."Music/.directory".text = ''
    [Desktop Entry]
    Icon=folder-white-music
  '';

  home.file."Pictures/.directory".text = ''
    [Desktop Entry]
    Icon=folder-yellow-pictures
  '';

  home.file."Videos/.directory".text = ''
    [Desktop Entry]
    Icon=folder-orange-video
  '';

  home.file."Public/.directory".text = ''
    [Desktop Entry]
    Icon=folder-pink-public
  '';

  home.file."Templates/.directory".text = ''
    [Desktop Entry]
    Icon=folder-brown-templates
  '';

  home.file."code/.directory".text = ''
    [Desktop Entry]
    Icon=folder-teal-code
  '';

  home.file."MEGA/.directory".text = ''
    [Desktop Entry]
    Icon=folder-red-meocloud
  '';
}
