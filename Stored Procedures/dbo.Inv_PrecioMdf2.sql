SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioMdf2]
@Id_Prec int,
@RucE nvarchar(11),
@Cd_Prod char(7),
@Id_UMP int,
@Descrip varchar(100),
@Cd_Mda nvarchar(2),
@PVta numeric(13,4),
@IB_IncIGV bit,
@IB_Exrdo bit,
@ValVta numeric(13,4),
@IC_TipDscto char(1),
@Dscto numeric(13,4),
@IC_TipVP varchar(1),
@MrgSup numeric(13,4),
@MrgInf numeric(13,4),
@IC_TipMU char(1),
@MrgUti numeric(13,4),
@Estado bit,
@IB_EsPrin bit,
@msj varchar(100) output
as
if not exists (select * from Precio where RucE=@RucE and Id_Prec=@Id_Prec)
	set @msj = 'Precio no existe'
else
begin
	begin transaction
	if(@IB_EsPrin = 1)	
		update Precio set IB_EsPrin = 0 where RucE = @RucE and Cd_Prod = @Cd_Prod and Id_UMP=@Id_UMP
	if exists (select* from Precio where RucE=@RucE and Id_Prec=@Id_Prec and IB_EsPrin= 1)
		if exists (select* from Precio where RucE=@RucE and Cd_Prod = @Cd_Prod and IB_EsPrin= 0)
			update Precio set IB_EsPrin = 1 where RucE=@RucE and Cd_Prod = @Cd_Prod and Id_Prec = (select top 1 Id_Prec from Precio where RucE=@RucE and Cd_Prod = @Cd_Prod and Id_Prec <> @Id_Prec)
	
	update Precio set Id_UMP=@Id_UMP,Descrip=@Descrip,Cd_Mda=@Cd_Mda, PVta=@PVta, IB_IncIGV=@IB_IncIGV, 
        IB_Exrdo=@IB_Exrdo,ValVta=@ValVta,IC_TipDscto=@IC_TipDscto,Dscto=@Dscto,IC_TipVP=@IC_TipVP,MrgSup=@MrgSup,MrgInf=@MrgInf,
	IC_TipMU=@IC_TipMU,MrgUti=@MrgUti,Estado=@Estado, IB_EsPrin = @IB_EsPrin
	where RucE=@RucE and Id_Prec=@Id_Prec

	if @@rowcount <= 0
	begin
		set @msj = 'Precio no pudo ser modificado'	
		rollback transaction
	end 
	else 
	begin
		commit transaction
		exec Inv_PrecioHistCrea @RucE,@Id_Prec,@PVta,@IB_IncIGV,@IB_Exrdo,@ValVta,@IC_TipDscto,@Dscto,@msj output
	end

end
-- Leyenda --
-- PP : 2010-03-01 		: <Creacion del procedimiento almacenado>
-- PP : 2010-03-19 11:33:37.060	: <Modificacion del procedimiento almacenado por el Id_Prec>
-- PP : 2010-03-19 13:30:29.440	: <Modificacion del procedimiento almacenado por el Historial >
-- CE : 2012-09-11 : <Modificacion de precios a 4 decimales>
GO
