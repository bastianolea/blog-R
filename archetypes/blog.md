---
title: "{{ replace .Name "-" " " | title }}"
author: Bastián Olea Herrera
date: {{ .Date }}
draft: true
tags:
categories:
format:
  hugo-md:
    output-file: "index"
    output-ext: "md"
execute:
  message: false
  warning: false
excerpt: "Resumen del post"
links:
  - icon: file-code
    icon_pack: fas
    name: Código
    url: https://github.com/bastianolea
---
