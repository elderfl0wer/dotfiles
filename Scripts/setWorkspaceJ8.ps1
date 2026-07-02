$env:JAVA_HOME="C:\Program Files\Eclipse Adoptium\jdk-8.0.482.8-hotspot"
$env:Path="$env:JAVA_HOME\bin;$env:Path"

Write-Host "JAVA_HOME set to $env:JAVA_HOME"
java -version