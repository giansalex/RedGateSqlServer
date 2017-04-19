SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Act_ConsultaEmpresas]

@msj varchar(100) output
as

select Ruc,RSocial as RSocial from Empresa

GO
