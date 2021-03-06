SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_GuiaXCompraCons] 
@RucE nvarchar(11),
@Cd_GR char(10),
@Cd_TDI nvarchar(2) output,
@NDoc nvarchar(15) output,
@RSocial varchar(150) output,
@msj varchar(100) output
as
declare @n int 
	select distinct S.NroSerie+ ' - '+V.NroDoc as Nro, Cd_Com from Compra as V 
		inner join Serie as S on V.RucE = S.RucE and V.NroSre = S.NroSerie
		where V.RucE = @RucE and V.Cd_Com in (select Cd_Com from GuiaXCompra where RucE = @RucE and Cd_GR = @Cd_GR) 
	/*set @n =( select count(*) from Auxiliar where RucE=@RucE and Cd_Aux in(select Cd_Cte from Venta where RucE = @RucE and Cd_Vta in (select Cd_Vta from GuiaXVenta where RucE = @RucE and Cd_GR = @Cd_GR)))*/
	/*set @n =(select count(*) from Cliente2 where RucE=@RucE and Cd_Clt in(select Cd_Clt from Venta where RucE=@RucE and Cd_vta in (select Cd_Vta from GuiaxVenta Where RucE=@RucE and Cd_GR=@Cd_GR)))*/
	set @n =(select count(*) from Proveedor2 where RucE=@RucE and Cd_Prv in(select Cd_Prv from Compra where RucE=@RucE and Cd_Com in (select Cd_Com from GuiaXCompra Where RucE=@RucE and Cd_GR=@Cd_GR)))
	if (@n =1)
 		/*select @Cd_TDI= Cd_TDI, @NDoc = NDoc, @RSocial = RSocial from Auxiliar where RucE=@RucE and Cd_Aux in(select Cd_Cte from Venta where RucE = @RucE and Cd_Vta in (select Cd_Vta from GuiaXVenta where RucE = @RucE and Cd_GR = @Cd_GR))*/
		/*select @Cd_TDI= Cd_TDI, @NDoc = NDoc, @RSocial = RSocial from Cliente2 where RucE=@RucE and Cd_Aux in(select Cd_Clt from Venta where RucE = @RucE and Cd_Vta in (select Cd_Vta from GuiaXVenta where RucE = @RucE and Cd_GR = @Cd_GR))*/		
		select @Cd_TDI= Cd_TDI, @NDoc = NDoc, @RSocial = RSocial from Proveedor2 where RucE=@RucE and Cd_Prv in(select Cd_Prv from Compra where RucE = @RucE and Cd_Com in (select Cd_Com from GuiaXCompra where RucE = @RucE and Cd_GR = @Cd_GR))
	if(@n>1)
	begin
		set @NDoc = 'Varios'
		set @RSocial = 'Varios'
	end
print @msj

-- Leyenda --
-- FL : 2010-10-21 : <Se creo el procedimiento almacenado>


GO
