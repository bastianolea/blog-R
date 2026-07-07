---
title: Colores y paletas de colores en R
subtitle: Todo sobre la creación, personalización, modificación y uso de colores y paletas en R
author: Bastián Olea Herrera
# date: '2025-03-06'
date: '2026-07-07'
format:
  hugo-md:
    output-file: "index"
    output-ext: "md"
    fig-height: 2
slug: []
categories: []
tags:
  - visualización de datos
  - ggplot2
execute:
  message: false
excerpt: "El uso del color es clave para comunicar, y el ecosistema de R tiene varios trucos convenientes para ayudarnos a usar el color de mejores formas. En este post reúno varios consejos y trucos para trabajar con colores: desde previsualizarlos, mezclarlos, combinarlos y usarlos como paletas en gráficos."
---

El uso del color es clave para comunicar, y el ecosistema de R tiene varios trucos convenientes para ayudarnos a usar el color de mejores formas.

En R, los colores se escriben como código, y a grandes rasgos pueden ser colores con **nombre** (por ejemplo, `"purple"`), colores **hexadecimales** (escritos como códigos de al menos 6 dígitos, como `#FFFFFF`), o como parte de funciones que producen **paletas** de colores.

## Usar colores

La forma más básica de elegir un color en R es por su *nombre*.
Por defecto, en R **existen 657 colores** con nombre.

Aquí puedes ver los principales colores de R y copiar sus nombres para usarlos:

<span style="background-color: #FFFFFF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #ABABAB ;">white</span>
<span style="background-color: #F0F8FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #72ADD2 ;">aliceblue</span>
<span style="background-color: #FAEBD7 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #BA9B64 ;">antiquewhite</span>
<span style="background-color: #FFEFDB ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C39C56 ;">antiquewhite1</span>
<span style="background-color: #EEDFCC ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AC9470 ;">antiquewhite2</span>
<span style="background-color: #CDC0B0 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #90816D ;">antiquewhite3</span>
<span style="background-color: #8B8378 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5F5A54 ;">antiquewhite4</span>
<span style="background-color: #7FFFD4 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #00B189 ;">aquamarine</span>
<span style="background-color: #76EEC6 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #07A680 ;">aquamarine2</span>
<span style="background-color: #66CDAA ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #338D71 ;">aquamarine3</span>
<span style="background-color: #458B74 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #2E6050 ;">aquamarine4</span>
<span style="background-color: #F0FFFF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #4FB9B9 ;">azure</span>
<span style="background-color: #E0EEEE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #84A4A4 ;">azure2</span>
<span style="background-color: #C1CDCD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #7C8C8C ;">azure3</span>
<span style="background-color: #838B8B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5A5F5F ;">azure4</span>
<span style="background-color: #F5F5DC ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A7A769 ;">beige</span>
<span style="background-color: #FFE4C4 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C39542 ;">bisque</span>
<span style="background-color: #EED5B7 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AF8D59 ;">bisque2</span>
<span style="background-color: #CDB79E ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #937B5B ;">bisque3</span>
<span style="background-color: #8B7D6B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5F564B ;">bisque4</span>
<span style="background-color: #000000 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #000000 ;">black</span>
<span style="background-color: #FFEBCD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C09B46 ;">blanchedalmond</span>
<span style="background-color: #0000FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #0606BA ;">blue</span>
<span style="background-color: #0000EE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #0505AE ;">blue2</span>
<span style="background-color: #0000CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #02029A ;">blue3</span>
<span style="background-color: #00008B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #02026D ;">blue4</span>
<span style="background-color: #8A2BE2 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #6700B1 ;">blueviolet</span>
<span style="background-color: #A52A2A ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #741F1F ;">brown</span>
<span style="background-color: #FF4040 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C10303 ;">brown1</span>
<span style="background-color: #EE3B3B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B21010 ;">brown2</span>
<span style="background-color: #CD3333 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #892C2C ;">brown3</span>
<span style="background-color: #8B2323 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #671515 ;">brown4</span>
<span style="background-color: #DEB887 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A27A36 ;">burlywood</span>
<span style="background-color: #FFD39B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C08A00 ;">burlywood1</span>
<span style="background-color: #EEC591 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B18127 ;">burlywood2</span>
<span style="background-color: #CDAA7D ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #927244 ;">burlywood3</span>
<span style="background-color: #8B7355 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #60503C ;">burlywood4</span>
<span style="background-color: #5F9EA0 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #446C6D ;">cadetblue</span>
<span style="background-color: #98F5FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #05ABB6 ;">cadetblue1</span>
<span style="background-color: #8EE5EE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #01A1AB ;">cadetblue2</span>
<span style="background-color: #7AC5CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #388990 ;">cadetblue3</span>
<span style="background-color: #53868B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #385D60 ;">cadetblue4</span>
<span style="background-color: #7FFF00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #54AC02 ;">chartreuse</span>
<span style="background-color: #76EE00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #4EA101 ;">chartreuse2</span>
<span style="background-color: #66CD00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #448C05 ;">chartreuse3</span>
<span style="background-color: #458B00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #2E6100 ;">chartreuse4</span>
<span style="background-color: #D2691E ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8F4920 ;">chocolate</span>
<span style="background-color: #FF7F24 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B35400 ;">chocolate1</span>
<span style="background-color: #EE7621 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A45019 ;">chocolate2</span>
<span style="background-color: #CD661D ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8D471D ;">chocolate3</span>
<span style="background-color: #8B4513 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #662E00 ;">chocolate4</span>
<span style="background-color: #FF7F50 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #BD4C00 ;">coral</span>
<span style="background-color: #FF7256 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C33C00 ;">coral1</span>
<span style="background-color: #EE6A50 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B03F22 ;">coral2</span>
<span style="background-color: #CD5B45 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8A4235 ;">coral3</span>
<span style="background-color: #8B3E2F ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #622C22 ;">coral4</span>
<span style="background-color: #6495ED ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #2A66B8 ;">cornflowerblue</span>
<span style="background-color: #FFF8DC ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B8A743 ;">cornsilk</span>
<span style="background-color: #EEE8CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A69D69 ;">cornsilk2</span>
<span style="background-color: #CDC8B1 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8D886A ;">cornsilk3</span>
<span style="background-color: #8B8878 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5F5D54 ;">cornsilk4</span>
<span style="background-color: #00FFFF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0AACAC ;">cyan</span>
<span style="background-color: #00EEEE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #09A1A1 ;">cyan2</span>
<span style="background-color: #00CDCD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #088B8B ;">cyan3</span>
<span style="background-color: #008B8B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #006060 ;">cyan4</span>
<span style="background-color: #B8860B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #7F5C05 ;">darkgoldenrod</span>
<span style="background-color: #FFB90F ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AE7D02 ;">darkgoldenrod1</span>
<span style="background-color: #EEAD0E ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A37500 ;">darkgoldenrod2</span>
<span style="background-color: #CD950C ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8D6502 ;">darkgoldenrod3</span>
<span style="background-color: #8B6508 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #624602 ;">darkgoldenrod4</span>
<span style="background-color: #006400 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #014701 ;">darkgreen</span>
<span style="background-color: #BDB76B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #817D3E ;">darkkhaki</span>
<span style="background-color: #8B008B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #660066 ;">darkmagenta</span>
<span style="background-color: #556B2F ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #384C0D ;">darkolivegreen</span>
<span style="background-color: #CAFF70 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #81AE03 ;">darkolivegreen1</span>
<span style="background-color: #BCEE68 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #78A306 ;">darkolivegreen2</span>
<span style="background-color: #A2CD5A ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #6A8C2A ;">darkolivegreen3</span>
<span style="background-color: #6E8B3D ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #4A6024 ;">darkolivegreen4</span>
<span style="background-color: #FF8C00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B05F01 ;">darkorange</span>
<span style="background-color: #FF7F00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B05601 ;">darkorange1</span>
<span style="background-color: #EE7600 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A55000 ;">darkorange2</span>
<span style="background-color: #CD6600 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8F4602 ;">darkorange3</span>
<span style="background-color: #8B4500 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #643001 ;">darkorange4</span>
<span style="background-color: #9932CC ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #6D2093 ;">darkorchid</span>
<span style="background-color: #BF3EFF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #9000C5 ;">darkorchid1</span>
<span style="background-color: #B23AEE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8601B9 ;">darkorchid2</span>
<span style="background-color: #9A32CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #6E2093 ;">darkorchid3</span>
<span style="background-color: #68228B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #530173 ;">darkorchid4</span>
<span style="background-color: #8B0000 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #670000 ;">darkred</span>
<span style="background-color: #E9967A ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B25C34 ;">darksalmon</span>
<span style="background-color: #8FBC8F ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #588258 ;">darkseagreen</span>
<span style="background-color: #C1FFC1 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #2DB92D ;">darkseagreen1</span>
<span style="background-color: #B4EEB4 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #4FA94F ;">darkseagreen2</span>
<span style="background-color: #9BCD9B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #559055 ;">darkseagreen3</span>
<span style="background-color: #698B69 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #4B5F4B ;">darkseagreen4</span>
<span style="background-color: #483D8B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #332B68 ;">darkslateblue</span>
<span style="background-color: #00CED1 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0F8C8E ;">darkturquoise</span>
<span style="background-color: #9400D3 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #6A0099 ;">darkviolet</span>
<span style="background-color: #FF1493 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B50166 ;">deeppink</span>
<span style="background-color: #EE1289 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AA005F ;">deeppink2</span>
<span style="background-color: #CD1076 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #940153 ;">deeppink3</span>
<span style="background-color: #8B0A50 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #68013A ;">deeppink4</span>
<span style="background-color: #00BFFF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0382AF ;">deepskyblue</span>
<span style="background-color: #00B2EE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0779A3 ;">deepskyblue2</span>
<span style="background-color: #009ACD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #016A8E ;">deepskyblue3</span>
<span style="background-color: #00688B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #004963 ;">deepskyblue4</span>
<span style="background-color: #1E90FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0C63B3 ;">dodgerblue</span>
<span style="background-color: #1C86EE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #225CA1 ;">dodgerblue2</span>
<span style="background-color: #1874CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #1C508D ;">dodgerblue3</span>
<span style="background-color: #104E8B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #003768 ;">dodgerblue4</span>
<span style="background-color: #B22222 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #7F1919 ;">firebrick</span>
<span style="background-color: #FF3030 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #BB0303 ;">firebrick1</span>
<span style="background-color: #EE2C2C ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AE0808 ;">firebrick2</span>
<span style="background-color: #CD2626 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #8D2121 ;">firebrick3</span>
<span style="background-color: #8B1A1A ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #6B0606 ;">firebrick4</span>
<span style="background-color: #FFFAF0 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #BFA65E ;">floralwhite</span>
<span style="background-color: #228B22 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #046204 ;">forestgreen</span>
<span style="background-color: #DCDCDC ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #949494 ;">gainsboro</span>
<span style="background-color: #F8F8FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #9E9EF7 ;">ghostwhite</span>
<span style="background-color: #FFD700 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AD9101 ;">gold</span>
<span style="background-color: #EEC900 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A28800 ;">gold2</span>
<span style="background-color: #CDAD00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8C7607 ;">gold3</span>
<span style="background-color: #8B7500 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #615103 ;">gold4</span>
<span style="background-color: #DAA520 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #967004 ;">goldenrod</span>
<span style="background-color: #FFC125 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AE8207 ;">goldenrod1</span>
<span style="background-color: #EEB422 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A37A05 ;">goldenrod2</span>
<span style="background-color: #CD9B1D ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8E6901 ;">goldenrod3</span>
<span style="background-color: #8B6914 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #624903 ;">goldenrod4</span>
<span style="background-color: #00FF00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #09AC09 ;">green</span>
<span style="background-color: #00EE00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0AA10A ;">green2</span>
<span style="background-color: #00CD00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #078C07 ;">green3</span>
<span style="background-color: #008B00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #016101 ;">green4</span>
<span style="background-color: #ADFF2F ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #72AC09 ;">greenyellow</span>
<span style="background-color: #F0FFF0 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5CBD5C ;">honeydew</span>
<span style="background-color: #E0EEE0 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #86A686 ;">honeydew2</span>
<span style="background-color: #C1CDC1 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #7D8D7D ;">honeydew3</span>
<span style="background-color: #838B83 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5A5F5A ;">honeydew4</span>
<span style="background-color: #FF69B4 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #D00284 ;">hotpink</span>
<span style="background-color: #FF6EB4 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #D30284 ;">hotpink1</span>
<span style="background-color: #EE6AA7 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C12179 ;">hotpink2</span>
<span style="background-color: #CD6090 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #943D64 ;">hotpink3</span>
<span style="background-color: #8B3A62 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #642846 ;">hotpink4</span>
<span style="background-color: #CD5C5C ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #913E3E ;">indianred</span>
<span style="background-color: #FF6A6A ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #D60404 ;">indianred1</span>
<span style="background-color: #EE6363 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #BE2626 ;">indianred2</span>
<span style="background-color: #CD5555 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8F3A3A ;">indianred3</span>
<span style="background-color: #8B3A3A ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #612A2A ;">indianred4</span>
<span style="background-color: #FFFFF0 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AFAF47 ;">ivory</span>
<span style="background-color: #EEEEE0 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A1A182 ;">ivory2</span>
<span style="background-color: #CDCDC1 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8B8B7B ;">ivory3</span>
<span style="background-color: #8B8B83 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5F5F5A ;">ivory4</span>
<span style="background-color: #F0E68C ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A69C09 ;">khaki</span>
<span style="background-color: #FFF68F ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AFA60A ;">khaki1</span>
<span style="background-color: #EEE685 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A49C06 ;">khaki2</span>
<span style="background-color: #CDC673 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8D8732 ;">khaki3</span>
<span style="background-color: #8B864E ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #605C34 ;">khaki4</span>
<span style="background-color: #E6E6FA ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #9696D8 ;">lavender</span>
<span style="background-color: #FFF0F5 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #E487AD ;">lavenderblush</span>
<span style="background-color: #EEE0E5 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B0919D ;">lavenderblush2</span>
<span style="background-color: #CDC1C5 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #908186 ;">lavenderblush3</span>
<span style="background-color: #8B8386 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5F5A5C ;">lavenderblush4</span>
<span style="background-color: #7CFC00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #52AA05 ;">lawngreen</span>
<span style="background-color: #FFFACD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B3AA27 ;">lemonchiffon</span>
<span style="background-color: #EEE9BF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A59E55 ;">lemonchiffon2</span>
<span style="background-color: #CDC9A5 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8D895C ;">lemonchiffon3</span>
<span style="background-color: #8B8970 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5F5E4F ;">lemonchiffon4</span>
<span style="background-color: #ADD8E6 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5596A8 ;">lightblue</span>
<span style="background-color: #BFEFFF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #31A9C3 ;">lightblue1</span>
<span style="background-color: #B2DFEE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #509CB0 ;">lightblue2</span>
<span style="background-color: #9AC0CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #568593 ;">lightblue3</span>
<span style="background-color: #68838B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #495A5F ;">lightblue4</span>
<span style="background-color: #F08080 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C93737 ;">lightcoral</span>
<span style="background-color: #E0FFFF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #3FB8B8 ;">lightcyan</span>
<span style="background-color: #D1EEEE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #6EA6A6 ;">lightcyan2</span>
<span style="background-color: #B4CDCD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #6D8D8D ;">lightcyan3</span>
<span style="background-color: #7A8B8B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #555F5F ;">lightcyan4</span>
<span style="background-color: #EEDD82 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A69502 ;">lightgoldenrod</span>
<span style="background-color: #FFEC8B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B29F05 ;">lightgoldenrod1</span>
<span style="background-color: #EEDC82 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A69501 ;">lightgoldenrod2</span>
<span style="background-color: #CDBE70 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8E8132 ;">lightgoldenrod3</span>
<span style="background-color: #8B814C ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #605933 ;">lightgoldenrod4</span>
<span style="background-color: #FAFAD2 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #ABAB47 ;">lightgoldenrodyellow</span>
<span style="background-color: #90EE90 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #06AA06 ;">lightgreen</span>
<span style="background-color: #FFB6C1 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #DD5D77 ;">lightpink</span>
<span style="background-color: #FFAEB9 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #DD5770 ;">lightpink1</span>
<span style="background-color: #EEA2AD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C15C6E ;">lightpink2</span>
<span style="background-color: #CD8C95 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #995963 ;">lightpink3</span>
<span style="background-color: #8B5F65 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #5E4347 ;">lightpink4</span>
<span style="background-color: #FFA07A ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C85E00 ;">lightsalmon</span>
<span style="background-color: #EE9572 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B65B26 ;">lightsalmon2</span>
<span style="background-color: #CD8162 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #90573F ;">lightsalmon3</span>
<span style="background-color: #8B5742 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #603D30 ;">lightsalmon4</span>
<span style="background-color: #20B2AA ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #057A75 ;">lightseagreen</span>
<span style="background-color: #87CEFA ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0890C0 ;">lightskyblue</span>
<span style="background-color: #B0E2FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #319FC8 ;">lightskyblue1</span>
<span style="background-color: #A4D3EE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #4793B4 ;">lightskyblue2</span>
<span style="background-color: #8DB6CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #507E94 ;">lightskyblue3</span>
<span style="background-color: #607B8B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #44555F ;">lightskyblue4</span>
<span style="background-color: #8470FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5925FF ;">lightslateblue</span>
<span style="background-color: #B0C4DE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #6A86A6 ;">lightsteelblue</span>
<span style="background-color: #CAE1FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5E9BD3 ;">lightsteelblue1</span>
<span style="background-color: #BCD2EE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #6A90B7 ;">lightsteelblue2</span>
<span style="background-color: #A2B5CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #647C97 ;">lightsteelblue3</span>
<span style="background-color: #6E7B8B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #4D555E ;">lightsteelblue4</span>
<span style="background-color: #FFFFE0 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AFAF37 ;">lightyellow</span>
<span style="background-color: #EEEED1 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A2A26A ;">lightyellow2</span>
<span style="background-color: #CDCDB4 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8B8B6C ;">lightyellow3</span>
<span style="background-color: #8B8B7A ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5F5F55 ;">lightyellow4</span>
<span style="background-color: #32CD32 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #1D8C1D ;">limegreen</span>
<span style="background-color: #FAF0E6 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #BB9E79 ;">linen</span>
<span style="background-color: #FF00FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B201B2 ;">magenta</span>
<span style="background-color: #EE00EE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A700A7 ;">magenta2</span>
<span style="background-color: #CD00CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #910091 ;">magenta3</span>
<span style="background-color: #B03060 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #7A2543 ;">maroon</span>
<span style="background-color: #FF34B3 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #BA007F ;">maroon1</span>
<span style="background-color: #EE30A7 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AF0077 ;">maroon2</span>
<span style="background-color: #CD2990 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #921865 ;">maroon3</span>
<span style="background-color: #8B1C62 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #6C0149 ;">maroon4</span>
<span style="background-color: #BA55D3 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8A2F9E ;">mediumorchid</span>
<span style="background-color: #E066FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B400D2 ;">mediumorchid1</span>
<span style="background-color: #D15FEE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A900C5 ;">mediumorchid2</span>
<span style="background-color: #B452CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #833196 ;">mediumorchid3</span>
<span style="background-color: #7A378B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #5B2169 ;">mediumorchid4</span>
<span style="background-color: #9370DB ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #6B43B1 ;">mediumpurple</span>
<span style="background-color: #AB82FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8732F5 ;">mediumpurple1</span>
<span style="background-color: #9F79EE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #7A3AD8 ;">mediumpurple2</span>
<span style="background-color: #8968CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #61449B ;">mediumpurple3</span>
<span style="background-color: #5D478B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #423263 ;">mediumpurple4</span>
<span style="background-color: #3CB371 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #327A50 ;">mediumseagreen</span>
<span style="background-color: #7B68EE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5433D9 ;">mediumslateblue</span>
<span style="background-color: #00FA9A ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0BA967 ;">mediumspringgreen</span>
<span style="background-color: #48D1CC ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #07908C ;">mediumturquoise</span>
<span style="background-color: #C71585 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #90015E ;">mediumvioletred</span>
<span style="background-color: #191970 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #020272 ;">midnightblue</span>
<span style="background-color: #F5FFFA ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5BBB94 ;">mintcream</span>
<span style="background-color: #FFE4E1 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #DD8679 ;">mistyrose</span>
<span style="background-color: #EED5D2 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B58982 ;">mistyrose2</span>
<span style="background-color: #CDB7B5 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #947977 ;">mistyrose3</span>
<span style="background-color: #8B7D7B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5F5655 ;">mistyrose4</span>
<span style="background-color: #FFE4B5 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #BE9723 ;">moccasin</span>
<span style="background-color: #FFDEAD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #BF921A ;">navajowhite</span>
<span style="background-color: #EECFA1 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AF893C ;">navajowhite2</span>
<span style="background-color: #CDB38B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #92784B ;">navajowhite3</span>
<span style="background-color: #8B795E ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5F5442 ;">navajowhite4</span>
<span style="background-color: #000080 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #020266 ;">navy</span>
<span style="background-color: #FDF5E6 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #BBA364 ;">oldlace</span>
<span style="background-color: #6B8E23 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #476300 ;">olivedrab</span>
<span style="background-color: #C0FF3E ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #7EAD08 ;">olivedrab1</span>
<span style="background-color: #B3EE3A ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #76A200 ;">olivedrab2</span>
<span style="background-color: #9ACD32 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #678B1C ;">olivedrab3</span>
<span style="background-color: #698B22 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #466100 ;">olivedrab4</span>
<span style="background-color: #FFA500 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AE7005 ;">orange</span>
<span style="background-color: #EE9A00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A36800 ;">orange2</span>
<span style="background-color: #CD8500 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8E5B00 ;">orange3</span>
<span style="background-color: #8B5A00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #633E00 ;">orange4</span>
<span style="background-color: #FF4500 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AD341A ;">orangered</span>
<span style="background-color: #EE4000 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A42E11 ;">orangered2</span>
<span style="background-color: #CD3700 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #922400 ;">orangered3</span>
<span style="background-color: #8B2500 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #661900 ;">orangered4</span>
<span style="background-color: #DA70D6 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A837A5 ;">orchid</span>
<span style="background-color: #FF83FA ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #D604D1 ;">orchid1</span>
<span style="background-color: #EE7AE9 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C80DC3 ;">orchid2</span>
<span style="background-color: #CD69C9 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #983D94 ;">orchid3</span>
<span style="background-color: #8B4789 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #633161 ;">orchid4</span>
<span style="background-color: #EEE8AA ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A59E35 ;">palegoldenrod</span>
<span style="background-color: #98FB98 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0CB30C ;">palegreen</span>
<span style="background-color: #9AFF9A ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0FB50F ;">palegreen1</span>
<span style="background-color: #7CCD7C ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #3F8F3F ;">palegreen3</span>
<span style="background-color: #548B54 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #3B603B ;">palegreen4</span>
<span style="background-color: #AFEEEE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #3CA8A8 ;">paleturquoise</span>
<span style="background-color: #BBFFFF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #00B6B6 ;">paleturquoise1</span>
<span style="background-color: #AEEEEE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #3AA8A8 ;">paleturquoise2</span>
<span style="background-color: #96CDCD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #4C8F8F ;">paleturquoise3</span>
<span style="background-color: #668B8B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #485F5F ;">paleturquoise4</span>
<span style="background-color: #DB7093 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A64065 ;">palevioletred</span>
<span style="background-color: #FF82AB ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #DC1C75 ;">palevioletred1</span>
<span style="background-color: #EE799F ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C4316D ;">palevioletred2</span>
<span style="background-color: #CD6889 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #94435E ;">palevioletred3</span>
<span style="background-color: #8B475D ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #603341 ;">palevioletred4</span>
<span style="background-color: #FFEFD5 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C09E4B ;">papayawhip</span>
<span style="background-color: #FFDAB9 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C58C3E ;">peachpuff</span>
<span style="background-color: #EECBAD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B28553 ;">peachpuff2</span>
<span style="background-color: #CDAF95 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #947556 ;">peachpuff3</span>
<span style="background-color: #8B7765 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5F5248 ;">peachpuff4</span>
<span style="background-color: #CD853F ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8C5B2E ;">peru</span>
<span style="background-color: #FFC0CB ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #DE6581 ;">pink</span>
<span style="background-color: #FFB5C5 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #DD5C80 ;">pink1</span>
<span style="background-color: #EEA9B8 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C0617A ;">pink2</span>
<span style="background-color: #CD919E ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #9A5C6B ;">pink3</span>
<span style="background-color: #8B636C ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5E464B ;">pink4</span>
<span style="background-color: #DDA0DD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AC5DAC ;">plum</span>
<span style="background-color: #FFBBFF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #DB55DB ;">plum1</span>
<span style="background-color: #EEAEEE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #BF5FBF ;">plum2</span>
<span style="background-color: #CD96CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #9A5C9A ;">plum3</span>
<span style="background-color: #8B668B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5F485F ;">plum4</span>
<span style="background-color: #B0E0E6 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #529DA4 ;">powderblue</span>
<span style="background-color: #A020F0 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #7402B2 ;">purple</span>
<span style="background-color: #9B30FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #7201C4 ;">purple1</span>
<span style="background-color: #912CEE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #6C01B8 ;">purple2</span>
<span style="background-color: #7D26CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #5C0C9D ;">purple3</span>
<span style="background-color: #551A8B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #440075 ;">purple4</span>
<span style="background-color: #FF0000 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B30303 ;">red</span>
<span style="background-color: #EE0000 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A80202 ;">red2</span>
<span style="background-color: #CD0000 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #930101 ;">red3</span>
<span style="background-color: #BC8F8F ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #875F5F ;">rosybrown</span>
<span style="background-color: #FFC1C1 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #E06767 ;">rosybrown1</span>
<span style="background-color: #EEB4B4 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C06C6C ;">rosybrown2</span>
<span style="background-color: #CD9B9B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #9A6363 ;">rosybrown3</span>
<span style="background-color: #8B6969 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5E4A4A ;">rosybrown4</span>
<span style="background-color: #4169E1 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #2948A3 ;">royalblue</span>
<span style="background-color: #4876FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #004ECD ;">royalblue1</span>
<span style="background-color: #436EEE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #1E4AB5 ;">royalblue2</span>
<span style="background-color: #3A5FCD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #2E438A ;">royalblue3</span>
<span style="background-color: #27408B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #152D6C ;">royalblue4</span>
<span style="background-color: #FA8072 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #D03700 ;">salmon</span>
<span style="background-color: #FF8C69 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C65000 ;">salmon1</span>
<span style="background-color: #EE8262 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B34F25 ;">salmon2</span>
<span style="background-color: #CD7054 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8D4D3B ;">salmon3</span>
<span style="background-color: #8B4C39 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #61362A ;">salmon4</span>
<span style="background-color: #F4A460 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B36A02 ;">sandybrown</span>
<span style="background-color: #2E8B57 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #18613A ;">seagreen</span>
<span style="background-color: #54FF9F ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #07AF62 ;">seagreen1</span>
<span style="background-color: #4EEE94 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #03A35B ;">seagreen2</span>
<span style="background-color: #43CD80 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #328B58 ;">seagreen3</span>
<span style="background-color: #FFF5EE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #CC9D6E ;">seashell</span>
<span style="background-color: #EEE5DE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AB9888 ;">seashell2</span>
<span style="background-color: #CDC5BF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8F847D ;">seashell3</span>
<span style="background-color: #8B8682 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5F5C5A ;">seashell4</span>
<span style="background-color: #A0522D ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #6F3A23 ;">sienna</span>
<span style="background-color: #FF8247 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #BA5200 ;">sienna1</span>
<span style="background-color: #EE7942 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AA4F1C ;">sienna2</span>
<span style="background-color: #CD6839 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #894A32 ;">sienna3</span>
<span style="background-color: #8B4726 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #643118 ;">sienna4</span>
<span style="background-color: #87CEEB ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0991B1 ;">skyblue</span>
<span style="background-color: #87CEFF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0C8FC4 ;">skyblue1</span>
<span style="background-color: #7EC0EE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0C86B8 ;">skyblue2</span>
<span style="background-color: #6CA6CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #3F7292 ;">skyblue3</span>
<span style="background-color: #4A708B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #344E61 ;">skyblue4</span>
<span style="background-color: #6A5ACD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #4A3C9A ;">slateblue</span>
<span style="background-color: #836FFF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5824FF ;">slateblue1</span>
<span style="background-color: #7A67EE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5332D9 ;">slateblue2</span>
<span style="background-color: #6959CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #493B9A ;">slateblue3</span>
<span style="background-color: #473C8B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #332A68 ;">slateblue4</span>
<span style="background-color: #FFFAFA ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #E89191 ;">snow</span>
<span style="background-color: #EEE9E9 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A89B9B ;">snow2</span>
<span style="background-color: #CDC9C9 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8D8787 ;">snow3</span>
<span style="background-color: #8B8989 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5F5E5E ;">snow4</span>
<span style="background-color: #00FF7F ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #1BAC57 ;">springgreen</span>
<span style="background-color: #00EE76 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #05A14E ;">springgreen2</span>
<span style="background-color: #00CD66 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #068C44 ;">springgreen3</span>
<span style="background-color: #008B45 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #00612E ;">springgreen4</span>
<span style="background-color: #4682B4 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #385978 ;">steelblue</span>
<span style="background-color: #63B8FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #007FBF ;">steelblue1</span>
<span style="background-color: #5CACEE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #1177B2 ;">steelblue2</span>
<span style="background-color: #4F94CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #36668E ;">steelblue3</span>
<span style="background-color: #36648B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #244663 ;">steelblue4</span>
<span style="background-color: #D2B48C ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #977849 ;">tan</span>
<span style="background-color: #FFA54F ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B66D04 ;">tan1</span>
<span style="background-color: #EE9A49 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AA6604 ;">tan2</span>
<span style="background-color: #8B5A2B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #643E16 ;">tan4</span>
<span style="background-color: #D8BFD8 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #9E7C9E ;">thistle</span>
<span style="background-color: #FFE1FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #DE76DE ;">thistle1</span>
<span style="background-color: #EED2EE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B682B6 ;">thistle2</span>
<span style="background-color: #CDB5CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #947694 ;">thistle3</span>
<span style="background-color: #8B7B8B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5F555F ;">thistle4</span>
<span style="background-color: #FF6347 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #BF3400 ;">tomato</span>
<span style="background-color: #EE5C42 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AC381F ;">tomato2</span>
<span style="background-color: #CD4F39 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #883C32 ;">tomato3</span>
<span style="background-color: #8B3626 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #64261A ;">tomato4</span>
<span style="background-color: #40E0D0 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #05998D ;">turquoise</span>
<span style="background-color: #00F5FF ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0FA5AC ;">turquoise1</span>
<span style="background-color: #00E5EE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0E9BA1 ;">turquoise2</span>
<span style="background-color: #00C5CD ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #0D868C ;">turquoise3</span>
<span style="background-color: #00868B ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #055D61 ;">turquoise4</span>
<span style="background-color: #EE82EE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #C820C8 ;">violet</span>
<span style="background-color: #D02090 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #980367 ;">violetred</span>
<span style="background-color: #FF3E96 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #BE0268 ;">violetred1</span>
<span style="background-color: #EE3A8C ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B20762 ;">violetred2</span>
<span style="background-color: #CD3278 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8B2953 ;">violetred3</span>
<span style="background-color: #8B2252 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: white ; border: solid 1px #6B0C3B ;">violetred4</span>
<span style="background-color: #F5DEB3 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #B39442 ;">wheat</span>
<span style="background-color: #FFE7BA ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #BD9929 ;">wheat1</span>
<span style="background-color: #EED8AE ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #AC9049 ;">wheat2</span>
<span style="background-color: #CDBA96 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #917D52 ;">wheat3</span>
<span style="background-color: #8B7E66 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #5F5748 ;">wheat4</span>
<span style="background-color: #FFFF00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #ABAB00 ;">yellow</span>
<span style="background-color: #EEEE00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #A0A007 ;">yellow2</span>
<span style="background-color: #CDCD00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #8B8B08 ;">yellow3</span>
<span style="background-color: #8B8B00 ; color: black; border-radius: 4px; padding: 1px 4px; margin: 2px; line-height: 1.9; color: black ; border: solid 1px #606002 ;">yellow4</span>

Para usarlos, simplemente usa su nombre:

``` r
colores <- c("indianred", "steelblue", "grey60")
```

<div style="align-items: center; justify-content: center; text-align: center;">
<div style="background-color: #CD5C5C ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #A14A4A ;">indianred</div>
<div style="background-color: #4682B4 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #446687 ;">steelblue</div>
<div style="background-color: #999999 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #787878 ;">grey60</div>
</div>

Casi todos estos colores pueden ser modificados agregando un número del 1 al 4 al final del nombre; por ejemplo, `mediumorchid` puede hacerse levemente más claro o más oscuro:

``` r
escala <- c("mediumorchid", "mediumorchid1", "mediumorchid2", "mediumorchid3", "mediumorchid4")
```

<div style="align-items: center; justify-content: center; text-align: center;">
<div style="background-color: #BA55D3 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #983DAE ;">mediumorchid</div>
<div style="background-color: #E066FF ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #C331E2 ;">mediumorchid1</div>
<div style="background-color: #D15FEE ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #B532D1 ;">mediumorchid2</div>
<div style="background-color: #B452CD ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #913EA6 ;">mediumorchid3</div>
<div style="background-color: #7A378B ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: white ; border: solid 1px #642A72 ;">mediumorchid4</div>
</div>

Los grises (`gray`) tienen la particularidad de que puedes ponerles un número entre 1 y 99 para ajustar su brillo:

``` r
escala <- c("gray2", "gray10", "gray30", "gray50", "gray70", "gray90")
```

<div style="align-items: center; justify-content: center; text-align: center;">
<div style="background-color: #050505 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: white ; border: solid 1px #040404 ;">gray2</div>
<div style="background-color: #1A1A1A ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: white ; border: solid 1px #161616 ;">gray10</div>
<div style="background-color: #4D4D4D ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: white ; border: solid 1px #3E3E3E ;">gray30</div>
<div style="background-color: #7F7F7F ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #646464 ;">gray50</div>
<div style="background-color: #B3B3B3 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #8C8C8C ;">gray70</div>
<div style="background-color: #E5E5E5 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #B2B2B2 ;">gray90</div>
</div>

Si tienes **colores hexadecimales**, que puedes encontrar en internet en muchas páginas, como [coolors.co](https://coolors.co), recuerda ponerlos entre comillas y anteponer el signo gato:

``` r
colores <- c("#DEC5F2", "#9069C0", "#6E3A98")
```

<div style="align-items: center; justify-content: center; text-align: center;">
<div style="background-color: #DEC5F2 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #B595CD ;">#DEC5F2</div>
<div style="background-color: #9069C0 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #725399 ;">#9069C0</div>
<div style="background-color: #6E3A98 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: white ; border: solid 1px #582F7A ;">#6E3A98</div>
</div>

## Paletas de colores

Varios paquetes de R contienen sus propias paletas de colores prediseñadas. Uno de los conjuntos de paletas principales en visualización de datos, sobre todo para mapas, son las de [Color Brewer](https://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3), a las que puedes acceder con el paquete `{RColorBrewer}`:

``` r
RColorBrewer::display.brewer.all()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-9-1.png" alt="" width="960" />

Cuando elijas una de las paletas, puedes usarla [en cualquier gráfico de `{ggplot2}`](/blog/r_introduccion/tutorial_visualizacion_ggplot/) con la función `scale_color_brewer()` o `scale_fill_brewer()`, según corresponda:

``` r
library(ggplot2)

iris |> 
  ggplot() +
  aes(x = Sepal.Length, y = Sepal.Width, color = Species) +
  geom_point(size = 4, alpha = 0.7) +
  # usar la paleta "PuRd"
  scale_color_brewer(palette = "PuRd")
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-10-1.png" alt="" width="672" />

Con el paquete `{colorspace}` también podemos ver otras paletas disponibles:

``` r
library(colorspace)

colorspace::hcl_palettes(plot = TRUE)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-11-1.png" alt="" width="1152" />

Usar estas paletas en `{ggplot2}` es tan fácil como agregar la función de escala apropiada para definir los colores del gráfico:

``` r
iris |> 
  ggplot() +
  aes(Petal.Width, Sepal.Width, color = Sepal.Length) +
  geom_point(size = 4, alpha = 0.7) +
  # usar la paleta "Sunset" para una variable continua
  colorspace::scale_color_continuous_sequential(palette = "Sunset") +
  scale_y_continuous(expand = expansion(c(0, 0.1)))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-12-1.png" alt="" width="672" />

Encuentra una lista que compila todas las paletas de colores de la comunidad de R [en este repositorio.](https://github.com/EmilHvitfeldt/r-color-palettes)

## Usar paletas de colores

La forma más simple de usar colores en gráficos de `{ggplot2}` es definiéndolos en la escala de color apropiada.

{{< relacionada “/blog/r_introduccion/tutorial_visualizacion_ggplot/” >}}

Para una variable *discreta* o *categórica*, los colores se aplican en la capa `scale_color_manual()` y se aplican en el orden de la variable:

``` r
library(ggplot2)

iris |> 
  ggplot() +
  aes(Sepal.Width, Sepal.Length, 
      color = Species) +
  geom_point(size = 2, alpha = .8) +
  scale_color_manual(
    values = c("#cc3b7b", "#705ce6", "#668cf6")
  ) +
  theme(legend.title = element_blank(),
        axis.title = element_blank())
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-13-1.png" alt="" width="672" />

O bien, se puede aplicar cada color a cada valor específico de la variable:

``` r
iris |> 
  ggplot() +
  aes(Sepal.Width, Sepal.Length, 
      color = Species) +
  geom_point(size = 2, alpha = .8) +
  # especificar un color para cada valor de la variable
  scale_color_manual(
    values = c("versicolor" = "#cc3b7b", 
               "virginica" = "#705ce6", 
               "setosa" = "#668cf6")
  ) +
  theme(legend.title = element_blank(),
        axis.title = element_blank())
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-14-1.png" alt="" width="672" />

Muchas paquetes incorporan funciones de escalas de colores (`scale_color_x()`, `scale_fill_x()`) para aplicar una paleta de color fácilmente a un gráfico creado `{ggplot2}`.

``` r
library(ggplot2)
library(dplyr)
```

    ## Warning: package 'dplyr' was built under R version 4.4.3

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
# escalas para variables discretas
iris |> 
  ggplot() +
  geom_bar(aes(Petal.Width, fill = Species)) +
  colorspace::scale_fill_discrete_qualitative(palette = "Dark 3") +
  scale_y_continuous(expand = expansion(c(0, 0.1)))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-15-1.png" alt="" width="672" />

``` r
# escalas para variables continuas
iris |> 
  ggplot() +
  geom_point(aes(Sepal.Width, Sepal.Length, color = Petal.Width, size = Petal.Length), alpha = .8) +
  colorspace::scale_color_continuous_sequential(palette = "Sunset", na.value = "white") +
  guides(size = guide_legend(override.aes = list(color = "#784FA1")),
         color = guide_colorsteps()) +
  theme(legend.title = element_blank(),
        axis.title = element_blank())
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-15-2.png" alt="" width="672" />

``` r
# escalas para variables continuas
iris |> 
  ggplot() +
  geom_point(aes(Petal.Length, Sepal.Width, color = Petal.Width, size = Sepal.Length), alpha = .8) +
  viridis::scale_colour_viridis("viridis", na.value = "white") +
  guides(size = guide_legend(override.aes = list(color = "#88D181")),
         color = guide_colorsteps()) +
  theme(legend.title = element_blank(),
        axis.title = element_blank())
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-15-3.png" alt="" width="672" />

Algunas de las funciones para aplicar paletas de colores tienen funcionalidades extras. Por ejemplo, las funciones de `{colorspace}` permiten modificar sus paletas en términos de la saturación (*chroma*) y el brillo del color (*luminance*), entregándote más libertad al momento de definir una apariencia específica:

``` r
grafico <- iris |> 
  ggplot() +
  geom_point(aes(Sepal.Width, Sepal.Length, color = Petal.Width), size = 3, alpha = .8) +
  guides(color = guide_colorsteps()) +
  theme(legend.title = element_blank(),
        axis.title = element_blank())

grafico +
  colorspace::scale_color_continuous_sequential(
    palette = "TealGrn", 
    c1 = 50, # intensidad del color
    l1 = 60) # brillo del color
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-16-1.png" alt="" width="672" />

``` r
grafico +
  colorspace::scale_color_continuous_sequential(
    palette = "TealGrn", 
    c1 = 20, # intensidad del color
    l1 = 30) # brillo del color
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-16-2.png" alt="" width="672" />

{{< aviso “Si quieres aprender `{ggplot2}`, revisa [este tutorial sobre visualización de datos desde cero!](/blog/r_introduccion/tutorial_visualizacion_ggplot/)” >}}

## Crear paletas de colores

También podemos usar funciones de R para crear paletas de colores personalizadas a partir de uno o varios colores, o especificando los rangos de variación de los colores.

### Crear paletas secuenciales

Las paletas secuenciales consiste en un degradado entre dos o más colores. Suelen usarse para representar una variable continua o numérica, cuyo valor va cambiando de forma cuantitativa.

La función `sequential_hcl()` del paquete `{colorspace}` permite crear paletas secuenciales. El primer argumento es la **cantidad de colores** que deseas, y luego el **tono** desde el que quieres empezar la paleta:

``` r
colores <- colorspace::sequential_hcl(6, h = 300)
```

<div style="align-items: center; justify-content: center; text-align: center;">
<div style="background-color: #850094 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: white ; border: solid 1px #6D0179 ;">#850094</div>
<div style="background-color: #9757A3 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #73497B ;">#9757A3</div>
<div style="background-color: #B089B8 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #8D6A95 ;">#B089B8</div>
<div style="background-color: #C6B2CB ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #9D8AA2 ;">#C6B2CB</div>
<div style="background-color: #D8D1DA ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #AAA2AC ;">#D8D1DA</div>
<div style="background-color: #E2E2E2 ; width: 90px; height: 90px; font-size: 12px; border-radius: 50%; margin: 8px; display: inline-flex; word-break: break-all; align-items: center; justify-content: center; text-align: center; color: black ; border: solid 1px #B0B0B0 ;">#E2E2E2</div>
</div>

``` r
colores <- colorspace::sequential_hcl(8, h = c(300, 100)) |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-19-1.png" alt="" width="672" />

``` r
colores <- colorspace::sequential_hcl(5, h = 260,
                           c = c(45, 25), l = c(25, 85), power = .9) |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-20-1.png" alt="" width="672" />

También se pueden obtener vectores de colores a partir de las paletas existentes que vienen con el paquete `{colorspace}`:

``` r
colorspace::sequential_hcl(5, palette = "Red-Blue") |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-21-1.png" alt="" width="672" />

``` r
colorspace::sequential_hcl(5, palette = "Purple-Orange") |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-21-2.png" alt="" width="672" />

### Crear paletas cualitativas

Como su nombre ética, en las paletas cualitativas los colores van saltando para maximizar la diferencia entre ellos. Se utilizan para variables cualitativas, categóricas o discretas, donde cada elemento de una secuencia es independiente de los demás, y el objetivo del uso del color es poder distinguirlos.

La función `rainbow_hcl()` de `{colorspace}` entrega una típica paleta de arcoíris, pero con la posibilidad de modificar sus atributos de color en sus argumentos, tales como las tonalidades (*hue*) de inicio o final, la intensidad (*chroma*) de los tonos

``` r
colores <- colorspace::rainbow_hcl(7, c = 70) |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-22-1.png" alt="" width="672" />

``` r
colores <- colorspace::rainbow_hcl(7, c = 100, start = 190, end = 380) |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-22-2.png" alt="" width="672" />

``` r
colores <- colorspace::rainbow_hcl(6, c = 60, l = 30, start = 230, end = 370) |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-22-3.png" alt="" width="672" />
Éste tipo de paletas usualmente reúne colores en una escala tipo arcoíris, o bien reúne colores temáticos, distintos entre ellos, pero armónicos entre sí.

También pueden usarse los nombres de las paredes preexistentes para generar una secuencia cualitativa con ellos.

``` r
colores <- colorspace::qualitative_hcl(6, palette = "Cold", c = 80) |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-23-1.png" alt="" width="672" />

``` r
colores <- colorspace::qualitative_hcl(6, palette = "Warm", c = 80) |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-23-2.png" alt="" width="672" />

### Crear paletas divergentes

Las paletas divergentes se utilizan cuando una variable expresa a dos polos, una una misma magnitud donde los extremos son separados por una brecha central.

``` r
colorspace::diverging_hcl(n = 5, h = c(200, 300)) |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-24-1.png" alt="" width="672" />

``` r
colorspace::diverging_hcl(n = 7, h = c(700, 180)) |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-24-2.png" alt="" width="672" />

``` r
colorspace::diverging_hcl(n = 7, h = c(700, 180), c = 130, alpha = .7) |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-24-3.png" alt="" width="672" />

### Extender paletas de colores

Si tienes un vector de colores y necesitas alargarlo para tener más colores basados en la paleta original, puedes hacerlo con la función `colorRampPalette()`. Esta función crea otra *función* a partir de los colores, a la que luego le das el número de colores que necesites obtener a partir de la paleta original:

``` r
# paleta de 5 colores
colores <- c("#f4b43f", "#ec6a2d", "#cc3b7b", "#705ce6", "#668cf6")

swatch(colores)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-25-1.png" alt="" width="672" />

``` r
# extender la paleta de 5 colores a 12 colores
colorRampPalette(colores)(12) |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-25-2.png" alt="" width="672" />

También podemos usar esta función para crear con facilidad una paleta secuencial entre dos o más colores:

``` r
colores <- c("#df65b2", "#fae55f")

# extender la paleta a 8 colores
colorRampPalette(colores)(8) |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-26-1.png" alt="" width="672" />

## Personalizar y crear colores

### Modificar colores existentes

Las funciones del paquete `{shades}` nos permitan obtener información detallada sobre cada uno de los colores, y usar esta misma información para modificarlos con mucho detalle.

Por ejemplo, definamos un color, y luego obtengamos el valor de su tonalidad. Recordemos que la tonalidad de los colores se expresan como grados entre 0° y 360°.

``` r
library(shades)

color <- "#f65b74"

swatch(color)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-27-1.png" alt="" width="672" />

``` r
hue(color)
```

    ## [1] 350.3226

Obtenemos que, para el color definido, el valor de su tonalidad es 350. Podemos usar esta información para modificar levemente el mismo color y así obtener una variable del mismo color levemente más anaranjada.

``` r
swatch(c(color, hue(color, 370)))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-28-1.png" alt="" width="672" />

Podemos obtener mismos resultados utilizando el *delta* de la tonalidad del color; es decir, sumándole restándole una cantidad de grados a el valor de la tonalidad del color mismo:

``` r
swatch(c(color, hue(color, delta(50))))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-29-1.png" alt="" width="672" />
Al usar la función `delta()`, lo que hacemos es pedirle que cambie la tonalidad del color en 50°, volviéndose en un tono amarillo.

Podemos obtener un resultado similar usando `col_shift()` del paquete `{scales}`:

``` r
library(scales)
show_col(c(color, col_shift(color, 20)))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-30-1.png" alt="" width="672" />

El **brillo** (*brighness*) va de cero a uno, mientras que la claridad (*lightness*) va de cero a 100.

``` r
color |> brightness(0.7) |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-31-1.png" alt="" width="672" />

``` r
color |> lightness(delta(20)) |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-31-2.png" alt="" width="672" />

Con `{scales}`, la función `col_lighter()` realiza el mismo propósito:

``` r
col_lighter(color, 20) |> show_col()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-32-1.png" alt="" width="672" />

Por su parte, la **saturación** aumenta la intensidad del color.

``` r
color |> saturation(delta(30)) |> swatch()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-33-1.png" alt="" width="672" />

Podemos utilizar la función `delta()` para crear una sencilla paleta de colores a partir de un mismo color, aumentando y disminuyendo su intensidad (*chroma*):

``` r
swatch(
  c(color |> chroma(delta(30)), 
    color,
    color |> chroma(delta(-30)))
)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-34-1.png" alt="" width="672" />

En `{scales}`, la función es `col_saturate()`:

``` r
col_saturate(color, -50) |> show_col()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-35-1.png" alt="" width="672" />

Podemos combinar estas técnicas para crear una paleta de colores más compleja, construida toda a partir de un solo color al cual se le va aumentando o disminuyendo sus valores de claridad e intensidad. El beneficio de hacerlo de esta manera es que luego basta con cambiar el color principal para obtener una paleta de iguales características, pero basada en una tonalidad distinta.

``` r
color_principal = "#4D4484"

color_fondo = color_principal |> lightness(13) |> chroma(20)
color_detalle = color_principal |> lightness(20) |> chroma(40)
color_destacado = color_principal |> lightness(50) |> chroma(65)
color_texto = color_principal |> lightness(80)

swatch(c(color_principal,
         color_fondo,
         color_detalle,
         color_destacado,
         color_texto))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-36-1.png" alt="" width="672" />

``` r
color_principal = "#3170ac"

color_fondo = color_principal |> lightness(13) |> chroma(20)
color_detalle = color_principal |> lightness(20) |> chroma(40)
color_destacado = color_principal |> lightness(50) |> chroma(65)
color_texto = color_principal |> lightness(80)

swatch(c(color_principal,
         color_fondo,
         color_detalle,
         color_destacado,
         color_texto))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-37-1.png" alt="" width="672" />

Notar que el código es igual, y sólo se cambió el valor del `color_principal`. Esta estrategia es muy útil si se están produciendo visualizaciones o aplicaciones que ocupan una paleta de colores monocroma.

### Mezclar colores

Las funciones `submix()` y `addmix()` del paquete {shades} facilitan el mezclado de colores sustraje ctivo y aditivo, respectivamente. A partir de dos colores, entrega la mezcla de ellos, abriendo muchas posibilidades para la experimentación y creación de nuevos colores:

``` r
swatch(c("#70f1d5",
         submix("#70f1d5", "#fae55f"),
         "#fae55f"))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-38-1.png" alt="" width="672" />

``` r
swatch(c("#3377f7",
         addmix("#3377f7", "#ec4e3c"),
         "#ec4e3c"))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-39-1.png" alt="" width="672" />

``` r
swatch(c("#f9ce45",
         submix("#f9ce45", "#77d671", amount = 0.5),
         "#77d671"))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-40-1.png" alt="" width="672" />

El paquete `{scales}` también provee una función para mezclar colores. Se puede usar esta función para tomar una paleta de colores y volverla más coherente al aplicarle una pequeña fracción de otro color, en este caso naranja:

``` r
col_mix(a = c("#77d671", "#70f1d5", "#fae55f", "#ff479c"),
        b = "orange2", 
        amount = 0.2) |> show_col()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-41-1.png" alt="" width="672" />

### Crear colores

Puedes crear un color en R definiendo su tonalidad (*hue*), saturación (*saturation*) y brillo (*value*) con `hsv()`, entendiendo que el matiz es la posición del color en la escala de todos los colores, que va del 0 al 1, empezando y terminando con el rojo:

``` r
color <- hsv(h = 0, s = 1, v = 1)
swatch(color)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-42-1.png" alt="" width="672" />

Para guiarse, la siguiente gráfica muestra la tonalidad de colores entre `0` y `1`,

    ## Warning: package 'purrr' was built under R version 4.4.3

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-43-1.png" alt="" width="672" />

Siguiendo el gráfico anterior, vemos que el tono `0.8` corresponde al color morado, así que podemos crearlo con `hsv()`:

``` r
color <- hsv(0.85, 1, 1)
swatch(color)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-44-1.png" alt="" width="672" />

Luego podemos modificar la saturación y brillo del color con los otros dos argumentos de `hsv()`:

``` r
color <- hsv(0.82, 0.5, 0.4)
swatch(color)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-45-1.png" alt="" width="672" />

------------------------------------------------------------------------

{{< etiqueta “visualización de datos” >}}

## Previsualizar colores

A lo largo de esta publicación puede usar la función `swatch()` del paquete `{shades}` para previsualizar cualquier color o vector de colores. Una alternativa es la función `show_col()` de `{scales}`, que hace lo mismo.

``` r
library(shades)
library(scales)
```

``` r
colores <- c("#DEC5F2", "#9069C0", "#6E3A98")
```

{{< columnas >}}

{{< columna >}}

``` r
shades::swatch(colores)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-48-1.png" alt="" width="672" />

{{< columna >}}

``` r
scales::show_col(colores)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-49-1.png" alt="" width="1120" />

{{< fin_columnas >}}

## Avanzado

`{colorspace}` incluye funciones para poder visualizar secuencias de colores en proyecciones del espacio de color HCL (*hue, chroma, luminance*), lo que nos permite contextualizar las paletas en un espacio perceptual del color basado en estos tres parámetros.

``` r
colorspace::hclplot(sequential_hcl(7, h = 260, c = 80, l = c(35, 95), power = 1.5))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-50-1.png" alt="" width="672" />

``` r
colorspace::hclplot(sequential_hcl(7, h = c(260, 220), c = c(50, 75, 0), l = c(30, 95), power = 1))
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-50-2.png" alt="" width="672" />

------------------------------------------------------------------------

## Fuentes y recursos

- https://github.com/EmilHvitfeldt/r-color-palettes
- https://r-graph-gallery.com/ggplot2-color.html
- https://www.datanovia.com/en/blog/top-r-color-palettes-to-know-for-great-data-visualization/
- https://jbengler.github.io/tidyplots/articles/Color-schemes.html
- https://emilhvitfeldt.com/post/2019-10-01-manipulating-colors-with-prismatic/index.html

{{< cafecito >}}
