SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_PrecioCrea]
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
@msj varchar(100) output
as
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

insert into Precio(Id_Prec,RucE,Cd_Prod,Id_UMP,Descrip,Cd_Mda,PVta,IB_IncIGV,IB_Exrdo,ValVta,IC_TipDscto,Dscto,IC_TipVP,MrgSup,MrgInf,IC_TipMU,MrgUti,Estado)
	values(@Id_Prec,@RucE,@Cd_Prod,@Id_UMP,@Descrip,@Cd_Mda,@PVta,@IB_IncIGV,@IB_Exrdo,@ValVta,@IC_TipDscto,@Dscto,@IC_TipVP,@MrgSup,@MrgInf,@IC_TipMU,@MrgUti,1)

if @@rowcount <= 0
	set @msj = 'Precio no pudo ser registrado'	
else 
	exec Inv_PrecioHistCrea @RucE,@Id_Prec,@PVta,@IB_IncIGV,@IB_Exrdo,@ValVta,@IC_TipDscto,@Dscto,@msj output


print @msj
end


-- Leyenda --
-- PP : 2010-03-19 11:28:22.240	: <Modificacion del procedimiento almacenado por el Id_Prec>
-- PP : 2010-03-19 13:36:04.323	: <Modificacion del procedimiento almacenado por el Historial >


GO
