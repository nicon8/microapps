 <#
    .SYNOPSIS
        Citrix Microapps webhook example.

    .DESCRIPTION
        Example of powershell able to send information directly to Citrix Workspace Microapps.

    .PARAMETER Check
        If 1 it prints the json example (useful to copy in the Citrix cloud panel)
        If 0 does not print the result

    .PARAMETER Notify
        Specify where the system notify the results of the script

    .EXAMPLE
        GetComputerInfoMicroapps.ps1 1 #first run, gives the json output of the script
        GetComputerInfoMicroapps.ps1 0 citrix #no output and notify to citrix
        GetComputerInfoMicroapps.ps1 1 citrix #print json and notify to citrix
        GetComputerInfoMicroapps.ps1 0 #do nothing :)

    .LINK
        webhook listener https://docs.citrix.com/en-us/citrix-microapps/build-a-custom-application-integration/create-http-integration.html

    .NOTES
        Setup url,token and prefix to authorize the script to push data to Citrix cloud

    #>


$prefix = "Basic"

$url = ""
$token = ""
<#
$data = @{
  "_id"="ab5"
  "field1"="Ciao"
  "field2"="Ciao"
}
#>

function Main {
  return Get-ComputerInfo 
  #return Get-WmiObject Win32_Processor 
  
}

function MicroAppsNotify {
param (
     [Parameter(Mandatory=$true)][Object] $data,
     [Parameter(Mandatory=$true)][String] $url,
     [Parameter(Mandatory=$true)][String] $token,
     [Parameter(Mandatory=$true)][String] $prefix
     )
$body = $data | ConvertTo-Json

<#
#No Auth
$header = @{
 "Accept"="application/json"
 "Content-Type"="application/json"
} 
#>

#Basic token generated
#Prefix: Basic
$header = @{
 "Authorization"= "$($prefix) $($token)"
 "Accept"="application/json"
 "Content-Type"="application/json"
} 

Invoke-RestMethod -Uri $url -Method 'Post' -Body $body -Headers $header

}

$check = $args[0]
$notify = $args[1]

#Execute main function
$data = Main | ConvertTo-Json

if ($check -eq 1){
    Write-Output $data
} 

if ($notify){
switch($notify) {
    "citrix" {MicroAppsNotify $data $url $token $prefix}
}
}