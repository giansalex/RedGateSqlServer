SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioMdf]
@Id_Prec int,
@RucE nvarchar(11),
@Cd_Prod char(7),
@Id_UMP int,
@Descrip varchar(100),
@Cd_Mda nvarchar(2),
@PVta numeric(13,2),
@IB_IncIGV bit,
@IB_Exrdo bit,
@ValVta numeric(13,2),
@IC_TipDscto char(1),
@Dscto numeric(13,2),
@IC_TipVP varchar(1),
@MrgSup numeric(13,2),
@MrgInf numeric(13,2),
@IC_TipMU char(1),
@MrgUti numeric(13,3),
@Estado bit,
@msj varchar(100) output
as
if not exists (select * from Precio where RucE=@RucE and Id_Prec=@Id_Prec)
	set @msj = 'Precio no existe'
else
begin
	update Precio set Id_UMP=@Id_UMP,Descrip=@Descrip,Cd_Mda=@Cd_Mda, PVta=@PVta, IB_IncIGV=@IB_IncIGV, 
        IB_Exrdo=@IB_Exrdo,ValVta=@ValVta,IC_TipDscto=@IC_TipDscto,Dscto=@Dscto,IC_TipVP=@IC_TipVP,MrgSup=@MrgSup,MrgInf=@MrgInf,
	IC_TipMU=@IC_TipMU,MrgUti=@MrgUti,Estado=@Estado
	where RucE=@RucE and Id_Prec=@Id_Prec

	if @@rowcount <= 0
	   set @msj = 'Precio no pudo ser modificado'	
	else 
		exec Inv_PrecioHistCrea @RucE,@Id_Prec,@PVta,@IB_IncIGV,@IB_Exrdo,@ValVta,@IC_TipDscto,@Dscto,@msj output

print @msj
end
-- Leyenda --
-- PP : 2010-03-01 		: <Creacion del procedimiento almacenado>
-- PP : 2010-03-19 11:33:37.060	: <Modificacion del procedimiento almacenado por el Id_Prec>
-- PP : 2010-03-19 13:30:29.440	: <Modificacion del procedimiento almacenado por el Historial >
GO
