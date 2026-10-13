{{- $nombre := .Get 0 -}}
{{- $termino := site.GetPage (printf "categories/%s" ($nombre | lower | replaceRE "\\s+" "-")) -}}
{{- with $termino -}}
**{{ $.Get 1 | default (printf "Publicaciones sobre %s" $nombre) }}:**

{{ range where .Pages.ByDate.Reverse "RelPermalink" "ne" $.Page.RelPermalink | first 5 -}}
{{- $url := .Permalink -}}
{{- with .OutputFormats.Get "markdown" }}{{ $url = .Permalink }}{{ end -}}
- [{{ .Title | markdownify | plainify | htmlUnescape }}]({{ $url }})
{{ end -}}
{{- end -}}
