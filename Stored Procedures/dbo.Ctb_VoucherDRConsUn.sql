SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherDRConsUn]
@RucE nvarchar(11),
@Cd_Vou int,
@msj varchar(100) output
as
--select Cd_Prf, NomP, Descrip, Estado from Perfil
if not exists (select * from VoucherDR where Cd_Vou=@Cd_Vou)
   set @msj = 'Documento Referencia no existe'
else select * from VoucherDR where Cd_Vou=@Cd_Vou
print @msj 

GO
