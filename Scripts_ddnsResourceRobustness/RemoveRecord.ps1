# Set the following parameters #
$dnsServerIp = "<Target DNS Server IP Address>"
$ddnsVirtualHostname = "<ddns resource virtuaul hostname>"
$dnsZoneName = "<zone name for ddns record>"
################################

$noRecord = "ObjectNotFound"
Get-DnsServerResourceRecord -ComputerName $dnsServerIp -ZoneName $dnsZoneName -Name $ddnsVirtualHostname
If($? -ne $true){
  $result = $Error[0].CategoryInfo | ForEach-Object {$_.Category}
  if($result -eq $noRecord){
    echo "SUCCESS: A Record has already been removed on DNS Server."
    exit 0
  }
}

echo "Removing A Record on DNS Server..."

Remove-DnsServerResourceRecord -ComputerName $dnsServerIp  -ZoneName $dnsZoneName -RRType A -Name $ddnsVirtualHostname -Force
if($? -ne $true){
    echo "ERROR: Filed to Removeing ."
    exit 1
}

echo "SUCCESS: Removed successfully."
exit 0
