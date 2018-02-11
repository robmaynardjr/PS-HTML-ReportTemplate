# CSS: Edit as needed. This controls what the report and elements in the report are displayed.
$CSS = @"
<style>

    body {
            margin: 0 auto;
            background-color: #272661;
            border-width: 15px; 
            border-style: solid; 
            border-color: black;
            border-collapse: collapse;
    }

    h1 { 
            background-color: black;
            align-items: center
            justify-content: center;
            vertical-align: middle;
            border: 0px solid black;
            text-align: Center;				
            color: green;
            font-family: Courier New, Courier, monospace;
            font-size: 38px;
            padding-top: 25px;
            padding-bottom: 25px;
    }


    h2 { 
            margin: 0 auto;
            background-color: Black;
            align-items: center
            justify-content: center;
            vertical-align: middle;
            border: 3px solid black;
            text-align: Center;				
            color: Green;
            font-family: Courier New, Courier, monospace;
            font-size: 28px;
            padding-top: 25px;
            padding-bottom: 25px;

    }

    TABLE {
            
            margin: 0 auto;
            border-width: 1px; 
            border-style: solid; 
            border-color: black;
            border-collapse: collapse;
            background-color: black;
            background-color: black;
            align-items: center
            justify-content: center;
            vertical-align: middle;
            border: 0px solid black;
            text-align: Center;				
            color: green;
            font-family: Courier New, Courier, monospace;
            padding-top: 25px;
            padding-bottom: 25px;
    }

    TH {
        border-width: 1px; 
        font-size: 20px; 
        padding: 3px; 
        border-style: solid; 
        border-color: gray;
        background-color: black; 
    }
    
    TD {
        border-width: 1px; 
        font-size: 18px;
        padding: 3px; 
        border-style: solid; 
        border-color: gray;
    }

</style>
"@

# Fill in path for HTML report
$outPath = <OutputFilepath>

# Sample Data for sample report output------------------------------------------------------------------------------------------------
$driveArray = @()
$drives = Get-PSDrive | Select-Object Name, Root, Used, Free
foreach ($d in $drives){
    
    $driveObj = New-Object PSobject
    $driveObj | Add-Member -MemberType NoteProperty -Name Name -Value $d.Name
    $driveObj | Add-Member -MemberType NoteProperty -Name Root -Value $d.Root
    if ($d.Used -le 0 -or $d.Used -eq $null) {

        $driveObj | Add-Member -MemberType NoteProperty -Name 'UsedSpace(GB)' -Value $d.Used
    
    }
    else {

        $driveObj | Add-Member -MemberType NoteProperty -Name 'UsedSpace(GB)' -Value (($d.Used)/1GB).ToString(".00")

    }

    if ($d.Free -le 0 -or $d.Used -eq $null) {

        $driveObj | Add-Member -MemberType NoteProperty -Name 'FreeSpace(GB)' -Value $d.Free
    
    }
    else {

        $driveObj | Add-Member -MemberType NoteProperty -Name 'FreeSpace(GB)' -Value (($d.Free)/1GB).ToString(".00")
        
    }
    
    
    $driveArray += $driveObj

}

# End Sample Data Region--------------------------------------------------------------------------------------------------------------

# Save different Tables as 'Fragments' and include fragments in $body variable.
$driveInfo = $driveArray | ConvertTo-Html -Fragment 
$services = Get-Service | Select-Object Name, Status | ConvertTo-Html -Fragment

$body = "<h2>PS Drives</h2><br><br>$driveInfo<br><br><h2>Services Status</h2><br><br>$services<br><br>"

#Edit -Head <h1> to include desired Report Title. Can also save as variable for more elaborate header.
ConvertTo-Html -PreContent $css -Title 'System Report' -Head '<h1>Drives Service Report Test</h1>' -Body $body | Out-File $outPath


