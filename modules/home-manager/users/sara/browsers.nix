{ lib, ... }:

let
  bookmarks = import ../../lib/bookmarks.nix { inherit lib; };

  bookmarksList = [
    {
      name = "WhatsApp";
      url = "https://web.whatsapp.com/";
    }
    {
      name = "Google";
      folder = true;
      children = [
        {
          name = "Gmail";
          url = "https://accounts.google.com/b/0/AddMailService";
        }
        {
          name = "YouTube";
          url = "https://youtube.com/";
        }
        {
          name = "Mi unidad DRIVE";
          url = "https://drive.google.com/drive/u/0/my-drive";
        }
      ];
    }
    {
      name = "Colegio FJE";
      folder = true;
      children = [
        {
          name = "correu outlook";
          url = "https://outlook.office.com/mail/";
        }
        {
          name = "REGISTRE HORARI";
          url = "https://registrehorari.net.fje.edu/RH_personal/";
        }
        {
          name = "Webinar FEAC Pares de P5, P4 i P3 sense estrès! - YouTube";
          url = "https://www.youtube.com/watch?v=tSOyQ12Gbwg";
        }
        {
          name = "Edpuzzle-cole";
          url = "https://edpuzzle.com/classes/63f7bf74e9be474117ae370c";
        }
        {
          name = "21-22_Mòdul MALL PLURILÍNGÜE MOPI PIN";
          url = "https://classroom.google.com/u/0/c/NDIwNzgxMzI2ODY0";
        }
        {
          name = "Els meus diaris";
          url = "https://la.net.fje.edu/api2/serveis/informacions/diaris/blogs.php";
        }
        {
          name = "DIARIS 2324";
          url = "https://docs.google.com/document/d/189Gm7RoDpAlr7RMaz0a9ySlLG4yQB17yW3vAAanUUVc/edit";
        }
        {
          name = "CLASSROOM";
          url = "https://classroom.google.com/c/MjM1NjYyMzQ5NzJa";
        }
        {
          name = "6B G3 S.Codina 2526 - Fulls de càlcul de Google";
          url = "https://docs.google.com/spreadsheets/d/1SsuH3utERAEkR14zPQfEM1suJfn_apwVi1ILVOcVrLw/edit?gid=1664637124#gid=1664637124";
        }
        {
          name = "6è TEMPORTITZACIÓ ANGLÈS 2526.xlsx";
          url = "https://fje.sharepoint.com/:x:/r/sites/GD_SARRIA-NEI/_layouts/15/Doc.aspx?sourcedoc=%7BE948B25E-4E75-4937-8EE5-E8EABEE87F21%7D&file=6%C3%A8%20TEMPORTITZACI%C3%93%20ANGL%C3%88S%202526.xlsx&action=default&mobileredirect=true&DefaultItemOpen=1&wdOrigin=WAC.EXCEL.HOME-BUTTON%2CAPPHOME-WEB.FILEBROWSER.RECENT&wdPreviousSession=edb7c94f-a532-10ef-d4a7-86f1ec593c49&wdPreviousSessionSrc=Wac&ct=1768490747307";
        }
        {
          name = "llista NEI BG3 - Fulls de càlcul de Google";
          url = "https://docs.google.com/spreadsheets/d/1c1UbFdSCo8cj81hLWSn1D8jvqLsED143E3TfQu3UQ-0/edit?gid=0#gid=0";
        }
        {
          name = "MOPI5 2T Graella Sessions avaluació 2526.docx";
          url = "https://fje.sharepoint.com/:w:/r/sites/GD_SARRIA-INF-EQUIP_DIRECTIU/_layouts/15/Doc.aspx?sourcedoc=%7BEB2F11A3-44D3-4AD2-A11E-2B72499EFDBD%7D&file=MOPI5%202T%20Graella%20Sessions%20avaluaci%C3%B3%202526.docx&action=default&mobileredirect=true&DefaultItemOpen=1&wdOrigin=WAC.WORD.HOME-BUTTON%2CAPPHOME-WEB.FILEBROWSER.RECENT&wdPreviousSession=bddff2f3-2206-e3cb-5935-fcf3f1c48eff&wdPreviousSessionSrc=Wac&ct=1768999789492";
        }
        {
          name = "6è TEMPORTITZACIÓ ANGLÈS 2526.xlsx";
          url = "https://fje.sharepoint.com/:x:/r/sites/GD_SARRIA-NEI/_layouts/15/doc2.aspx?sourcedoc=%7BE948B25E-4E75-4937-8EE5-E8EABEE87F21%7D&file=6%C3%A8%20TEMPORTITZACI%C3%93%20ANGL%C3%88S%202526.xlsx&action=default&mobileredirect=true&CID=934c3e6c-f1b9-e335-d18a-dbbdd418e0bb";
        }
        {
          name = "Bandeja de entrada: Sara Codina Lletjos - Outlook";
          url = "https://outlook.cloud.microsoft/mail/inbox/id/AAQkAGUyOWQ5MjQwLTUxOGItNDgxMi04MzM2LTYzM2YyYTUxMmMwYwAQAHpYWGWVFBJHg%2FQRQUejs3s%3D";
        }
        {
          name = "documents compartits";
          url = "https://fje.sharepoint.com/sites/GestioDocumental/Pagines/default.aspx";
        }
        {
          name = "documnets compartits 2526";
          url = "https://fje.sharepoint.com/sites/GD_SARRIA-INF/Documentos%20compartidos/Forms/AllItems.aspx?id=%2Fsites%2FGD%5FSARRIA%2DINF%2FDocumentos%20compartidos%2FGeneral%2F2526%2F2526%20DOCUMENTS%20COMPARTITS&viewid=868de04a%2De4d8%2D497b%2Daef8%2D7ef5a4d263b6&FolderCTID=0x01200080FE14F59D721F44A6F1D392AC447BFC";
        }
        {
          name = "Dictations - 2nd term - 6th.docx";
          url = "https://fje.sharepoint.com/:w:/r/sites/GD_SARRIA-NEI/_layouts/15/Doc.aspx?sourcedoc=%7BFA6E557A-0429-5284-87E9-81E5A6995DD1%7D&file=Dictations%20-%202nd%20term%20-%206th.docx&action=default&mobileredirect=true";
        }
        {
          name = "6B G3 llistes";
          url = "https://docs.google.com/spreadsheets/d/1SsuH3utERAEkR14zPQfEM1suJfn_apwVi1ILVOcVrLw/edit?gid=772559926#gid=772559926";
        }
        {
          name = "laNET 4";
          url = "https://netapp.net.fje.edu/";
        }
        {
          name = "Dictations 3rd term Y6 2526 - Documents de Google";
          url = "https://docs.google.com/document/d/1AH-nGvCcnVGoxVzXkAb_XeOfhTBe0jdOS-y5T7y-iNQ/edit?tab=t.0";
        }
        {
          name = "p5 2nT";
          url = "https://fje.sharepoint.com/:w:/r/sites/GD_SARRIA-INF/_layouts/15/Doc.aspx?sourcedoc=%7B2A67E873-ED11-568E-1568-9D3EB01E1B98%7D&file=2526-2T%20INF5-LANG-PG.docx&action=default&mobileredirect=true";
        }
        {
          name = "p4 2nT";
          url = "https://fje.sharepoint.com/:w:/r/sites/GD_SARRIA-INF/_layouts/15/Doc.aspx?sourcedoc=%7B35F224CF-6CBA-5EBA-A19D-78584C926905%7D&file=2526-2T%20INF4%20LANG-PG.docx&action=default&mobileredirect=true";
        }
        {
          name = "3T INF5";
          url = "https://docs.google.com/document/d/1nTsJ06nCIyU4H8lDv0q2VFDQbIDLw8mc/edit#heading=h.1g05u1gvc0eh";
        }
        {
          name = "2223_Verticalitat Kide Science MOPI-PIN - Fulls de càlcul de Google";
          url = "https://docs.google.com/spreadsheets/d/1imPumtlwGmw_fqqrrbQdUoNU2dRQsS0_vgOIJJxQoQs/edit?gid=0#gid=0";
        }
        {
          name = "Substitució 12-14 maig - Documents de Google";
          url = "https://docs.google.com/document/d/1-s38abKpaUtGCp46sRPwLoGgdkET8C0dF-SPN2yf9dA/edit?tab=t.0";
        }
        {
          name = "2627-MOPI3-PG-ENGLISH.xlsx";
          url = "https://fje.sharepoint.com/:x:/r/sites/GD_SARRIA-INF/_layouts/15/Doc.aspx?sourcedoc=%7BFEB8E215-B7F3-4176-9A05-061C2C21C99B%7D&file=2627-MOPI3-PG-ENGLISH.xlsx&action=default&mobileredirect=true&DefaultItemOpen=1&wdOrigin=WAC.EXCEL.HOME-BUTTON%2CAPPHOME-WEB.JUMPBACKIN&wdPreviousSession=4344ca49-fddc-a7d2-fe63-23f69a3a0bfe&wdPreviousSessionSrc=Wac&ct=1782120160528";
        }
        {
          name = "GD_SARRIA-INF - ENGLISH - Todos los documentos";
          url = "https://fje.sharepoint.com/sites/GD_SARRIA-INF/Documentos%20compartidos/Forms/AllItems.aspx?id=%2Fsites%2FGD%5FSARRIA%2DINF%2FDocumentos%20compartidos%2FGeneral%2F2627%2FDOCUMENTS%20COMPARTITS%202627%2FENGLISH&viewid=868de04a%2De4d8%2D497b%2Daef8%2D7ef5a4d263b6&FolderCTID=0x01200080FE14F59D721F44A6F1D392AC447BFC";
        }
        {
          name = "REUNIÓ AMB DIRECCIÓ Anglès - juny 2026 - Documents de Google";
          url = "https://docs.google.com/document/d/1pH7QDEwbcN3UjZMFgBHgarDaMRA3Z0pazBcvs86W4tw/edit?tab=t.0";
        }
        {
          name = "2526- 5è i 6è Planificació JUNY.docx";
          url = "https://fje.sharepoint.com/:w:/s/GD_SARRIA-NEI/IQD0Iq3OTYs_SpXeSbEPSJ-lAVnsJTDaaPfCV3aJf5gWYkM?CID=75b6e2e2-9680-747d-b4ad-75cd3aa67b94&SI=NonSentItems";
        }
        {
          name = "dept edu Intranet - Portal de centre";
          url = "https://inici.espai.educacio.gencat.cat/";
        }
        {
          name = "Odissea";
          url = "https://odissea.xtec.cat/";
        }
        {
          name = "laNE";
          url = "https://netapp.net.fje.edu/#";
        }
      ];
    }
    {
      name = "Recursos educativos";
      folder = true;
      children = [
        {
          name = "edpuzzle-preguntes videos";
          url = "https://edpuzzle.com/discover";
        }
        {
          name = "Inicio - Canva";
          url = "https://www.canva.com/";
        }
        {
          name = "wordwall";
          url = "https://wordwall.net/es-ar/community";
        }
        {
          name = "English Exercises ESL";
          url = "https://agendaweb.org/";
        }
        {
          name = "40K+ Kids' Story Books, Educational Books, Videos & More | Epic";
          url = "https://www.getepic.com/books";
        }
        {
          name = "Efectes sonors. XTEC";
          url = "https://xtec.gencat.cat/ca/recursos/media/radio/biblioteca/efectes-sonors/";
        }
        {
          name = "Tablero del profesor | Cambridge One";
          url = "https://www.cambridgeone.org/dashboard/teacher/dashboard";
        }
        {
          name = "Juegos educacionales online para niños en preescolar";
          url = "https://www.tinytap.com/content/";
        }
        {
          name = "DECRET 21/2023, de 7 de febrer, d'ordenació dels ensenyaments de l'educació infantil.";
          url = "https://dogc.gencat.cat/ca/document-del-dogc/?documentId=951431";
        }
        {
          name = "Buscar HELPER - Canva";
          url = "https://www.canva.com/search?q=HELPER";
        }
        {
          name = "geografia acivitats";
          url = "https://activitum.cat/activitats/?ActividadesSearch%5Btipo%5D=families&etiq=1569";
        }
        {
          name = "book";
          url = "https://content.cambridgeone.org/cup1/products/bcessppl6ue/3/assets/online/1697795311969/webapp/index.html?rootPath=/cup1/products/bcessppl6ue/3/assets/online/1697795311969/webapp/#/preview/512875";
        }
        {
          name = "eBook Level 6 | Be Curious Updated Edition Level 6";
          url = "https://www.cambridgeone.org/foc/org_cup_pAtuIe5AGk_Om7d1Hl_zb/product/bcbel6/studentbook/bcessebkl6/view?page=42";
        }
        {
          name = "ILT Education - Logga in";
          url = "https://auth.inlasningstjanst.se/v1/authorize?response_type=code&scope=openid+profile&client_id=b7f965cb00f549b3ab30&redirect_uri=https%3A%2F%2Fapp.ilteducation.se%2Flogin%3Fredirect%3D%252F%253F&code_challenge=o5zGTZzMi5Kx0K7aoNFW9UprEDY2Ttzjkw8n7-s3g60&code_challenge_method=S256";
        }
        {
          name = "Kide Lesson Plans";
          url = "https://teachers.kidescience.se/en";
        }
      ];
    }
    {
      name = "Personal";
      folder = true;
      children = [
        {
          name = "Adobe Acrobat";
          url = "https://acrobat.adobe.com/?x_api_client_id=bookmark&x_api_client_location=Reader";
        }
        {
          name = "KISS FM | En directo";
          url = "http://kissfm.es/player/";
        }
        {
          name = "Camino Neocatecumenal – Sitio oficial – «Humildad, sencillez y alabanza»";
          url = "https://neocatechumenaleiter.org/";
        }
        {
          name = "spotify";
          url = "https://open.spotify.com/intl-es/track/0TZvKu6X4kwYmG3eHhIKMX";
        }
      ];
    }
    {
      name = "UIC";
      folder = true;
      children = [
        {
          name = "Credenciales - gsync-UIC";
          url = "https://console.developers.google.com/apis/credentials?project=radiant-planet-166407";
        }
        {
          name = "DEBUGGER-serv1";
          url = "http://my-web.uic.es/serv1/common_apps/WDE/WebTools/controls/primera.uic";
        }
      ];
    }
  ];
in
{
  xdg.configFile."BraveSoftware/Brave-Browser/Default/Bookmarks" = {
    force = true;
    text = bookmarks.buildBookmarks bookmarksList;
  };

  programs.brave = {
    enable = true;
    extensions = [
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
    ];
  };
}
