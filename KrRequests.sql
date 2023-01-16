-- 1. Получите список управляющих файлов.
/*SELECT NAME FROM V$C0NTR0LFILE; в sqlplus*/

-- 2. Сформируйте PFILE.
/*CREATE PFILE='init.ora' FROM SPFILE; в sqlplus от sysdba*/


-- 3. Создайте таблицу из двух столбцов, один из которых первичный ключ. Получите перечень всех сегментов. Вставьте данные в таблицу. Определите, сколько в сегменте таблицы экстентов, их размер в блоках и байтах.

CREATE TABLE TEST (ID NUMBER(10) PRIMARY KEY, NAME VARCHAR2(20));
SELECT SEGMENT_NAME, SEGMENT_TYPE FROM USER_SEGMENTS;
INSERT INTO TEST VALUES (1, 'TEST');
SELECT SEGMENT_NAME, SEGMENT_TYPE, EXTENTS, BLOCKS, BYTES FROM USER_SEGMENTS;

-- 4. Получите перечень всех процессов СУБД Oracle. Для серверных процессов укажите режим подключения. Для фоновых укажите работающие в настоящий момент.

SELECT SID, SERIAL#, USERNAME, STATUS, PROCESS, MACHINE, PROGRAM, TYPE, LOGON_TIME FROM V$SESSION;

SELECT SID, SERIAL#, USERNAME, STATUS, PROCESS, MACHINE, PROGRAM, TYPE, LOGON_TIME FROM V$SESSION WHERE TYPE = 'BACKGROUND' AND STATUS = 'ACTIVE';

-- 5. Получите перечень всех табличных пространств и их файлов.
select TABLESPACE_NAME, contents logging from SYS.DBA_TABLESPACES;

select FILE_NAME,TABLESPACE_NAME,STATUS, MAXBYTES,USER_BYTES from DBA_DATA_FILES
UNION
SELECT FILE_NAME,TABLESPACE_NAME,STATUS, MAXBYTES,USER_BYTES from DBA_TEMP_FILES;

-- 6. Получите перечень всех ролей.
select * from DBA_ROLES ;

-- 7. Получите перечень привилегий для определенной роли.
select * from DBA_SYS_PRIVS where GRANTEE = 'ROLE_NAME';

-- 8. Получите перечень всех пользователей.
select * from dba_users;

-- 9. Создайте роль;
CREATE ROLE TEST_ROLE;

-- 10. Создайте пользователя.
create user HTACORE identified by HTACORE;

-- 11. Получите перечень всех профилей безопасности.
select * from DBA_PROFILES;

-- 12. Получите перечень всех параметров профиля безопасности.
select * from DBA_PROFILES WHERE PROFILE = "PROFILE_NAME";

-- 13. Создайте профиль безопасности.
create profile HTACORE limit PASSWORD_LIFE_TIME UNLIMITED;

-- 14.Найдите синонимы в представлениях словаря Oracle.
select * from dba_synonyms where table_owner = 'SYS';

-- 15. Получите перечень всех групп журналов повтора.
select * from v$logfile;

-- 16. Определите текущую группу журналов повтора.
select * from v$logfile where status = 'CURRENT';
-- 17. Получите перечень файлов всех журналов повтора.
select * from v$log;
-- 18. Создайте таблицу и вставьте в нее 100 записей. Найдите таблицу и ее свойства в представлениях словаря.
CREATE TABLE TESTT (ID NUMBER(10) PRIMARY KEY, NAME VARCHAR2(20));
begin for i in 1..100 loop insert into TESTT values (i, 'TESTT'); end loop; end;
select * from dba_tables where table_name = 'TESTT';
-- 19. Получите список сегментов табличного пространства.
select * from dba_segments where tablespace_name = 'HTACORE';
-- 20. Подсчитайте размер данных в таблице.
select sum(bytes) from dba_segments where tablespace_name = 'HTACORE';
-- 21. Вычислите количество блоков, занятых таблицей.
select sum(blocks) from dba_segments where tablespace_name = 'HTACORE';
-- 22. Выведите список сессий.
select * from v$session;
-- 23. Выведите, производится ли архивирование журналов повтора.
select * from v$archive_dest_status;


