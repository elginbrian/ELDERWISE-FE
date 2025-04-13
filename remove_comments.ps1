$projectRoot = "d:\elderwise"
$dartFiles = Get-ChildItem -Path $projectRoot -Filter "*.dart" -Recurse

foreach ($file in $dartFiles) {
    Write-Host "Processing: $($file.FullName)"
    
    $content = Get-Content -Path $file.FullName
    
    $newContent = @()
    
    foreach ($line in $content) {
        if ($line -match '^\s*//') {
            continue
        }
        
        if ($line -match '//') {
            if ($line -match 'https?://') {
                $parts = $line -split '//'
                $isComment = $true
                
                for ($i = 0; $i -lt $parts.Count - 1; $i++) {
                    if ($parts[$i].TrimEnd() -match '(^|[^:])https?:$') {
                        $isComment = $false
                        break
                    }
                }
                
                if ($isComment) {
                    $commentStart = -1
                    $inString = $false
                    $escapeNext = $false
                    
                    for ($i = 0; $i -lt $line.Length - 1; $i++) {
                        $c = $line[$i]
                        $next = $line[$i+1]
                        
                        if (($c -eq '"' -or $c -eq "'") -and -not $escapeNext) {
                            $inString = -not $inString
                        }
                        
                        $escapeNext = $c -eq '\' -and -not $escapeNext
                        
                        if (-not $inString -and $c -eq '/' -and $next -eq '/') {
                            $commentStart = $i
                            break
                        }
                    }
                    
                    if ($commentStart -ge 0) {
                        $newContent += $line.Substring(0, $commentStart).TrimEnd()
                    } else {
                        $newContent += $line
                    }
                } else {
                    $newContent += $line
                }
            } else {
                $commentStart = $line.IndexOf('//')
                $newContent += $line.Substring(0, $commentStart).TrimEnd()
            }
        } else {
            $newContent += $line
        }
    }
    
    Set-Content -Path $file.FullName -Value $newContent
}

Write-Host "Comment removal completed!"
