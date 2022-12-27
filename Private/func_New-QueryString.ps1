function New-QueryString([hashtable]$Parameters) {
    $queryString = ""
    foreach ($key in $Parameters.Keys) {
        if ($queryString -eq "") {
            $queryString = "?"
        }
        else {
            $queryString += "&"
        }
        $queryString += "$($key)=$($Parameters[$key])"
    }
    return $queryString
}