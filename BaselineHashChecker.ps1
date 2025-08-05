# Import baseline
$baseline = Import-Csv "C:\baseline_hashes.csv"

# Scan and compare
$changes = @()

foreach ($file in $baseline) {
    if (Test-Path $file.FilePath) {
        $currentHash = (Get-FileHash -Path $file.FilePath -Algorithm SHA256).Hash
        if ($currentHash -ne $file.Hash) {
            $changes += [PSCustomObject]@{
                FilePath    = $file.FilePath
                OldHash     = $file.Hash
                NewHash     = $currentHash
                Status      = "Modified"
            }
        }
    } else {
        $changes += [PSCustomObject]@{
            FilePath    = $file.FilePath
            OldHash     = $file.Hash
            NewHash     = "N/A"
            Status      = "Deleted"
        }
    }
}

# Detect new files
$baselinePaths = $baseline.FilePath
$newFiles = Get-ChildItem -Path "C:\" -Recurse -File | Where-Object { $_.FullName -notin $baselinePaths }
foreach ($file in $newFiles) {
    $changes += [PSCustomObject]@{
        FilePath    = $file.FullName
        OldHash     = "N/A"
        NewHash     = (Get-FileHash -Path $file.FullName -Algorithm SHA256).Hash
        Status      = "New"
    }
}

$changes | Export-Csv "C:\hash_changes.csv" -NoTypeInformation
