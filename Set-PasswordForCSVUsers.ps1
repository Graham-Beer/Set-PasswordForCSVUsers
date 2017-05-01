function Set-PasswordForCSVUsers {

  param(
    [string]$header1 = 'UPN',
    [string]$header2 = 'Password',
    [string]$CSVfile = 'd:\TestEmailaddress.csv',
    [int]$length = 8,
    [string]$outputFile 
  )  
  
  # Import CSV file with headers defined in Advanced Parameters
  $content = Import-Csv $CSVfile -Encoding UTF8 -Header $header1, $header2   
    
    # Get count of users in list and add password to each one
    for ($i = 0; $i -lt $content.$header1.Count; $i++) {
            
            # Set letters, upper and lowercase
            $upper = [Char[]](65..90); $lower = [Char[]](97..122)

            # Add some special characters
            $special = [Char[]]'&!@$%'

            # Create an arraylist
            $bucket = New-Object -TypeName System.Collections.ArrayList
            
            # Generate password based on length
            $null = $bucket.Add((Get-Random -Maximum 10)) # Add a random number from 1 to 10
            $null = $bucket.Add((Get-Random -Count 1 -InputObject $special)) # Add one special character
            (Get-Random -Count (($length-2) /2) -InputObject $upper).Foreach{$null = $bucket.Add($_)} # Take 2 of the length, divide by 2 and add uppercase characters
            (Get-Random -Count (($length-2) /2) -InputObject $lower).Foreach{$null = $bucket.Add($_)} # Take 2 of the length, divide by 2 and add lowercase characters

            # mix up the lowercase, uppercase and special characters in the variable
            $bucket = Get-Random -Count $length -InputObject $bucket
            
            $content[$i] | foreach {
                # foreach user join the characters in the variable for password
                $_.$header2 = $(-join $bucket) ; return $_
        }
    }
    if($outputFile) {
        # Export content to new file
        $content | Export-Csv -Path $outputFile -Encoding UTF8 -NoTypeInformation
    }
}