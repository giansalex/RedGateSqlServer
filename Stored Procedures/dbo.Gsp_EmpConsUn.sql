SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Gsp_EmpConsUn]
@Ruc nvarchar(11),
@msj varchar(100) output
as
if not exists (select * from Empresa Where Ruc=@Ruc)
	set @msj = 'Empresa no existe'
else select * from Empresa Where Ruc=@Ruc
print @msj
GO
