call git checkout master
call gitsync --tempdir "C:\Temp\Sync" --v8version 8.3.19.1529 sync --storage-user deploy --storage-pwd _ tcp://localhost/mmm-service C:\Users\evgeniy.karpinskiy\source\1CRepos\mmm-service\src\config
call git push