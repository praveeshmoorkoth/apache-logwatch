# apachelogs

This script scan a given apache access log file for the number of HTTP 4xx and 5xx response statuses. If the cumulative number of errors exceeds 100, it alos sent an email alert to configured mail list. 

```
**Usage:  sh logwatch.sh <apache_log_file>**

Notes:
        param1 : Full path of the apache log file
```     
**Prerequisite :**
1. mailx utility (yum install mailx)
2. mailrc configuration file 


```
$ cat ~/.mailrc
set smtp-use-starttls
set nss-config-dir=/etc/pki/nssdb/
set ssl-verify=ignore
set smtp=smtp://smtp.gmail.com:587
set smtp-auth=login
set smtp-auth-user=praveeshtestgm@gmail.com
set smtp-auth-password=xxxxxxxxxxxx
set from="No-Reply <no-reply@moxtra.com>"
```
**Notes:**

1. Use the following sed commands to update the date/timestamp on the log entries for testing purpose
2. Email server configurations can be updated in the script itself.

```
$ sed -i 's/20\/Jul\/2021:09:/20\/Jul\/2021:02:/g' apache_access.log
$ sed -i 's/.png HTTP\/1.1\" 200/.png HTTP\/1.1\" 400/g' apache_access.log
```
