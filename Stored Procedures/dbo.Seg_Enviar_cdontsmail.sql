SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Seg_Enviar_cdontsmail] 
@From varchar(100),
@To varchar(100),
@Subject varchar(100),
@Body varchar(4000),
@CC varchar(100) = null,
@BCC varchar(100) = null
AS
Declare @MailID int
Declare @hr int
EXEC @hr = sp_OACreate 'CDONTS.NewMail', @MailID OUT
EXEC @hr = sp_OASetProperty @MailID, 'From',@From
EXEC @hr = sp_OASetProperty @MailID, 'Body', @Body
EXEC @hr = sp_OASetProperty @MailID, 'BCC',@BCC
EXEC @hr = sp_OASetProperty @MailID, 'CC', @CC
EXEC @hr = sp_OASetProperty @MailID, 'Subject', @Subject
EXEC @hr = sp_OASetProperty @MailID, 'To', @To
EXEC @hr = sp_OAMethod @MailID, 'Send', NULL
EXEC @hr = sp_OADestroy @MailID

-- LEYENDA
-- CAM 17/07/2012 creacion
GO
