@ECHO OFF
SET QUIZHOST=localhost
batchtool.exe > BACKUP-VAR.BAT
CALL BACKUP-VAR
MD  .\Daily-Backup\%BACKUP_FOLDER%
ECHO Dumping data to file .\Daily-Backup\%BACKUP_FOLDER%\backup-at-%BACKUP_FILE%.sql
mysqldump --user=root --password= --host=%QUIZHOST% -B $DATABASE > .\Daily-Backup\%BACKUP_FOLDER%\$DATABASE-backup-at-%BACKUP_FILE%.sql
