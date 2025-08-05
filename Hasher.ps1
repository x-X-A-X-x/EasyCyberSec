# Define directory to scan
$Path = "C:\"

# Generate hashes of all files
Get-ChildItem -Path $Path -Recurse -File | 
    ForEach-Object {
        $hash = Get-FileHash -Path $_.FullName -Algorithm SHA256
        [PSCustomObject]@{
            FilePath = $_.FullName
            Hash     = $hash.Hash
        }
    } | Export-Csv -Path "C:\baseline_hashes.csv" -NoTypeInformation
