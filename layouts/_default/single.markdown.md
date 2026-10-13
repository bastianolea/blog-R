{{- $titulo := .Title | markdownify | plainify | htmlUnescape -}}
# {{ $titulo }}
{{ with .Params.subtitle }}
_{{ . | markdownify | plainify | htmlUnescape }}_
{{ end }}
{{- with .Params.excerpt }}
> {{ . | markdownify | plainify | htmlUnescape | replaceRE `\s+` " " | strings.TrimSpace }}
{{ end }}
- URL: {{ .Permalink }}
{{- if not .Date.IsZero }}
- Fecha: {{ .Date.Format "2006-01-02" }}
{{- end }}
- Autor: {{ .Params.author | default site.Params.orgName }}
{{- with .Params.tags }}
- Etiquetas: {{ delimit . ", " }}
{{- end }}
{{- with .Params.links }}
- Recursos:{{ range . }} [{{ .name }}]({{ .url | absURL }}){{ end }}
{{- end }}

---

{{ partial "llms/limpiar.html" (dict "page" . "texto" .RenderShortcodes) }}
