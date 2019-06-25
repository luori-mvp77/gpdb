set PGPORT=%1
set PGUSER=gpadmin
set PGHOST=127.0.0.1

call "C:\Program Files\Greenplum\greenplum-clients\greenplum_clients_path.bat"
set path=%path%;C:\Program Files\curl-win64-mingw\bin
psql -U gpadmin -p 15432 -h 127.0.0.1 -c "select version();" "dbname=postgres" || goto :error
psql -U gpadmin -p 15432 -h 127.0.0.1 -c "select version();" "dbname=postgres sslmode=require" || goto :error
start /B pipe_win10.exe
start /B gpfdist.exe -d \\.\pipe\
curl -H "X-GP-PROTO: 0" http://127.0.0.1:8080/public_test_0_pipe0 || goto :error
cd gpload2
python TEST_REMOTE.py || goto :error
exit /b 0

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%