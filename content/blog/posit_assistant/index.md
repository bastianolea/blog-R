---
title: Posit Assistant, un asistente de IA para programación y análisis de datos integrado en
  RStudio
author: Bastián Olea Herrera
date: '2026-04-21'
draft: true
slug: []
categories: []
tags:
  - blog
  - inteligencia artificial
format:
  hugo-md:
    output-file: index
    output-ext: md
---

Recientemente Posit, la empresa (corporación de beneficio público) detrás de RStudio, Positron, y muchos de los paquetes que más usamos en el ecosistema de R, [anunció la integración oficial de inteligencia artificial en RStudio](https://posit.co/blog/introducing-ai-in-rstudio).

**Posit Assistant** reside en la barra lateral de RStudio y sirve para hacer consultas a una IA relacionadas al análisis de datos, dentro del contexto del proyecto que estés realizando con R. 

Su potencial reside en que se **integra estrechamente** con tu trabajo: puede conocer los datos que estás explorando, sabe qué archivo tienes abierto, y puede ver los _scripts_ de tu proyecto.

Las capacidades de Posit Assistant van mucho más allá que las de cualquier otro _harness_ de inteligencia artificial (como Claude Code), dado que puede **ejecutar código de R en tu misma sesión**, lo que significa que entiende los datos que tienes cargados, puede acceder a tu entorno, y tiene la posibilidad de ejecutar código para **entender tus datos** y **experimentar* con ellos.

(Haiku, Sonnet, Opus)

Gemma 4

A diferencia de otros como Claude Code, puedes decirle cosas como "en este script" y sabe exactamente el script que estás mirando.

Es muy cuidadoso antes de hacer algo: revisa el proyecto entero e intenta comprenderlo para que lo que haga tenga consideración de toda la complejidad de tu trabajo.


### Mi experiencia 

Durante varias semanas he estado usando este servicio y mi veredicto es que es muy bueno.

Lo he usado en mi blog para implementar algunos cambios que personalmente no sabría cómo hacer, dado que no domino del todo el software (Hugo), y me gusta que puedo ver los archivos que modifica, pide permiso para acceder a ellos, y luego de que los modifica puedo presionar el nombre de los archivos para hacer modificaciones manualmente luego de entender lo que hizo.

También me gusta el **modo planificación** que te resume lo que va a hacer paso por paso, para que comprendas los cambios antes de aprobarlos y realizarlos.

También aprecio que puedes **cancelar una acción dándole indicaciones** para corregir el rumbo de lo que está haciendo.



### Privacidad 

Posit tiene un acuerdo con Anthropic para **mantener la privacidad de tus datos**, como indican en su [documentación](https://docs.posit.co/posit-ai/user/faq/#privacy-data-storage). Esta política de _cero retención de datos_ significa que los datos que envíes se descartan inmediatamente luego de ser usados para ofrecerte el servicio.



{{< imagen "posit_assistant_1.png" >}}

{{< imagen "posit_assistant_2.png" >}}

{{< imagen "posit_assistant_3.png" >}}