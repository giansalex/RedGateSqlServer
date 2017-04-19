SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Com_Proveedor2_EnviaEmail]
@From varchar(100) ,
@To varchar(100) ,
@Subject varchar(100)=" ",
@Body varchar(4000) =" "
/************************************************** *******************

This stored procedure takes the parameters and sends an e-mail.
All the mail configurations are hard-coded in the stored procedure.
Comments are added to the stored procedure where necessary.
References to the CDOSYS objects are at the following MSDN Web site:
http://msdn.microsoft.com/library/de..._messaging.asp

************************************************** *********************/
AS
Declare @iMsg int
Declare @hr int
Declare @source varchar(255)
Declare @description varchar(500)
Declare @output varchar(1000)

--************* Create the CDO.Message Object ************************
EXEC @hr = sp_OACreate 'CDO.Message', @iMsg OUT

--***************Configuring the Message Object ******************
-- This is to configure a remote SMTP server.
-- http://msdn.microsoft.com/library/de..._sendusing.asp
EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/sendusing").Value','2'
-- This is to configure the Server Name or IP address.
-- Replace MailServerName by the name or IP of your SMTP Server.
EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpserver").Value', 'CONTASERVER'

-- Save the configurations to the message object.
EXEC @hr = sp_OAMethod @iMsg, 'Configuration.Fields.Update', null

-- Set the e-mail parameters.
EXEC @hr = sp_OASetProperty @iMsg, 'To', @To
EXEC @hr = sp_OASetProperty @iMsg, 'From', @From
EXEC @hr = sp_OASetProperty @iMsg, 'Subject', @Subject

-- If you are using HTML e-mail, use 'HTMLBody' instead of 'TextBody'.
EXEC @hr = sp_OASetProperty @iMsg, 'TextBody', @Body
EXEC @hr = sp_OAMethod @iMsg, 'Send', NULL

-- Sample error handling.
IF @hr <>0
select @hr
BEGIN
EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
IF @hr = 0
BEGIN
SELECT @output = ' Source: ' + @source
PRINT @output
SELECT @output = ' Description: ' + @description
PRINT @output
END
ELSE
BEGIN
PRINT ' sp_OAGetErrorInfo failed.'
RETURN
END
END

-- Do some error handling after each step if you have to.
-- Clean up the objects created.
EXEC @hr = sp_OADestroy @iMsg





GO
