{{- $page := site.GetPage (.Get 0) -}}
{{- with $page -}}
{{- $url := .Permalink -}}
{{- with .OutputFormats.Get "markdown" }}{{ $url = .Permalink }}{{ end -}}
{{- $resumen := .Params.excerpt | default .Description -}}
**{{ $.Get 1 | default "Publicación relacionada" }}:** [{{ .Title | markdownify | plainify | htmlUnescape }}]({{ $url }}){{ with $resumen }}: {{ . | markdownify | plainify | htmlUnescape | replaceRE `\s+` " " | truncate 200 "…" }}{{ end }}
{{- end -}}
