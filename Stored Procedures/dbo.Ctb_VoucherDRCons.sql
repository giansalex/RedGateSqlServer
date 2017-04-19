SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_VoucherDRCons]
@RucE nvarchar(11),
@msj varchar(100) output
as
--select Cd_Prf, NomP, Descrip, Estado from Perfil
/*if not exists (select top 1 * from Perfil)
   set @msj = 'No se encontro Perfiles'
else */select * from VoucherDR
where RucE=@RucE
print @msj
GO
