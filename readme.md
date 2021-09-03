 #Automation Project
checks whether the HTTP Apache server is already installed. If not present, then it installs the server.Script 
checks whether the server is running or not. If it is not running, then it starts the server and also whether the service is enabled or not. 
After executing the script the tar file should be present in the correct format in the /tmp/ directory.Tar should be copied to the S3 bucket.
Two branches, the main and the Dev, are present in the repository Correct tags should be found in the Git repository. run a cron job.
When the script is executed, it should create /var/www/html/inventory.html with the proper header and append detail of 
copied Tar file in the next line. The script should never overwrite the present content of the file.
