SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Mnt_TipoMedioPagoConsUn]
@Cd_TMP char(3),
@msj varchar(100) output
as
if not exists (select * from MedioPago where Cd_TMP=@Cd_TMP)
	set @msj = 'Medio de pago no existe.'
else	select * from MedioPago where Cd_TMP=@Cd_TMP
print @msj
-- leyenda
-- cam 23/08/2012 creacion
GO
