{{ .Get 4 | default "Recurso externo" }}: [{{ .Get 0 }}]({{ .Get 1 }}){{ with .Get 3 }}: {{ . }}{{ end }}
