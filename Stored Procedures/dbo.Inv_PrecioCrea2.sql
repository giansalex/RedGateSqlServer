SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioCrea2]
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
@IB_EsPrin bit,
@msj varchar(100) output
as


/** start -- GG:  Validacion **/

--if not exists(select * from Moneda where  Cd_Mda=@Cd_Mda)
--begin
--	set @msj ='No existe moneda  de Moneda : ' + @Cd_Mda
--	return
--end

--if not exists(select * from  Prod_UM where RucE=@RucE and Cd_Prod=@Cd_Prod and ID_UMP=@Id_UMP )
--begin
--	set @msj ='No existe unidad de medida '+Convert(varchar(10),@Id_UMP)+' de Producto : ' +@Cd_Prod
--	return
--end

/** end -- GG:  Validacion **/


If exists(select * from Precio Where RucE = @RucE and Cd_Prod = @Cd_Prod and Id_UMP=@Id_UMP and Descrip=@Descrip and Cd_Mda=@Cd_Mda)
	set @msj = 'Ya existe el precio para la unidad de medida'
else
begin
if @IC_TipDscto is null
	set @Dscto = null
if @IC_TipVP is null
begin
	set @MrgSup = null
	set @MrgInf = null
end
if @IC_TipMU is null
	set @MrgUti = null
declare @Id_Prec int
set @Id_Prec =dbo.Id_Precio(@RucE)
begin transaction
if not exists(select * from Precio where RucE = @RucE and Cd_Prod = @Cd_Prod and Id_UMP=@Id_UMP)
	set @IB_EsPrin = 1
else
	if(@IB_EsPrin = 1)	
		update Precio set IB_EsPrin = 0 where RucE = @RucE and Cd_Prod = @Cd_Prod and Id_UMP=@Id_UMP

insert into Precio(Id_Prec,RucE,Cd_Prod,Id_UMP,Descrip,Cd_Mda,PVta,IB_IncIGV,IB_Exrdo,ValVta,IC_TipDscto,Dscto,IC_TipVP,MrgSup,MrgInf,IC_TipMU,MrgUti,Estado,IB_EsPrin)
	values(@Id_Prec,@RucE,@Cd_Prod,@Id_UMP,@Descrip,@Cd_Mda,@PVta,@IB_IncIGV,@IB_Exrdo,@ValVta,@IC_TipDscto,@Dscto,@IC_TipVP,@MrgSup,@MrgInf,@IC_TipMU,@MrgUti,1, @IB_EsPrin)

if @@rowcount <= 0begin	set @msj = 'Precio no pudo ser registrado'	
	rollback transaction
end
else
begin
	commit transaction
	exec Inv_PrecioHistCrea @RucE,@Id_Prec,@PVta,@IB_IncIGV,@IB_Exrdo,@ValVta,@IC_TipDscto,@Dscto,@msj output
end

print @msj
end

-- select * from Precio where RucE='20169999991'


-- Leyenda --
-- PP : 2010-03-19 11:28:22.240	: <Modificacion del procedimiento almacenado por el Id_Prec>
-- PP : 2010-03-19 13:36:04.323	: <Modificacion del procedimiento almacenado por el Historial >
-- CE : 2012-09-11 : <Modificacion de precios a 4 decimales>

GO
