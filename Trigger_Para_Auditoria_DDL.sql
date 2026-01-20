/********************************************************************************
 Autor: Luciano Silva
 Projeto: Auditoria DDL em Nível de Servidor
 Descrição: Captura eventos DDL (CREATE, ALTER, DROP) em nível de servidor
*********************************************************************************/

-- =============================================================================
-- BANCO DE AUDITORIA
-- =============================================================================
USE DBA;
GO

DROP TABLE IF EXISTS DBA.dbo.DBA_Audit_DDL_Server;
GO

CREATE TABLE DBA.dbo.DBA_Audit_DDL_Server
(
    DDL_AuditID     INT IDENTITY(1,1) PRIMARY KEY,
    DataHora        DATETIME2(0) NOT NULL,
    NomeBanco       SYSNAME NULL,
    NomeLogin       SYSNAME NULL,
    NomeDBUser      SYSNAME NULL,
    NomeHost        VARCHAR(256) NULL,
    Operacao        VARCHAR(200) NULL,
    Comando         VARCHAR(MAX) NULL,
    Notificacao     CHAR(1) NOT NULL DEFAULT ('N')
);
GO

-- =============================================================================
-- TRIGGER DDL EM NÍVEL DE SERVIDOR
-- =============================================================================
USE master;
GO

CREATE OR ALTER TRIGGER trg_AuditDDL_Server
ON ALL SERVER
WITH EXECUTE AS 'SRVSQL2022\luciano'
FOR DDL_SERVER_LEVEL_EVENTS
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @EventData     XML,
        @DataHora      DATETIME2(0),
        @NomeBanco     SYSNAME,
        @NomeLogin     SYSNAME,
        @NomeDBUser    SYSNAME,
        @NomeHost      VARCHAR(256),
        @Operacao      VARCHAR(200),
        @Comando       VARCHAR(MAX);

    SET @EventData = EVENTDATA();

    SET @DataHora  = CONVERT(DATETIME2(0), @EventData.value('(//PostTime)[1]', 'DATETIME2'));
    SET @NomeBanco = @EventData.value('(//DatabaseName)[1]', 'SYSNAME');
    SET @NomeLogin = @EventData.value('(//LoginName)[1]', 'SYSNAME');
    SET @Operacao  = @EventData.value('(//EventType)[1]', 'VARCHAR(200)');
    SET @Comando   = REPLACE(
                        @EventData.value('(//TSQLCommand/CommandText)[1]', 'VARCHAR(MAX)'),
                        CHAR(13), ''
                     );

    SET @NomeDBUser = USER_NAME();
    SET @NomeHost   = CONNECTIONPROPERTY('client_net_address');

    -- Evita registrar contas de serviço
    IF @NomeLogin NOT IN ('NT SERVICE\MSSQLSERVER', 'NT AUTHORITY\SYSTEM')
    BEGIN
        INSERT INTO DBA.dbo.DBA_Audit_DDL_Server
        (
            DataHora,
            NomeBanco,
            NomeLogin,
            NomeDBUser,
            NomeHost,
            Operacao,
            Comando
        )
        VALUES
        (
            @DataHora,
            @NomeBanco,
            @NomeLogin,
            @NomeDBUser,
            @NomeHost,
            @Operacao,
            @Comando
        );
    END
END;
GO

-- =============================================================================
-- CONTROLE DO TRIGGER
-- =============================================================================
-- DISABLE TRIGGER trg_AuditDDL_Server ON ALL SERVER;
-- ENABLE  TRIGGER trg_AuditDDL_Server ON ALL SERVER;
GO

-- =============================================================================
-- HANDS ON - VALIDAÇÃO DO PROJETO
-- =============================================================================
USE master;
GO

-- Login de teste
CREATE LOGIN TesteAudit 
WITH PASSWORD = '123',
CHECK_POLICY = OFF,
CHECK_EXPIRATION = OFF;
GO

EXEC sp_addsrvrolemember 
    @loginame = 'TesteAudit',
    @rolename = 'dbcreator';
GO

EXECUTE AS LOGIN = 'TesteAudit';

CREATE DATABASE TesteAudit;
GO
ALTER DATABASE TesteAudit SET RECOVERY SIMPLE;
GO
DROP DATABASE TesteAudit;
GO

REVERT;
GO
