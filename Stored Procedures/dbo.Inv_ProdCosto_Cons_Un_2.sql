SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [dbo].[Inv_ProdCosto_Cons_Un_2]
@RucE nvarchar(11),
@Cd_Prod char(7),
@TipCosto int,
@ID_UMP int,
@Costo float output,
@Costo_ME float output,
--------------------------------------
@msj varchar(100) output

as

if not exists (select Cd_Prod from producto2 where Cd_Prod = @Cd_Prod)
	set @msj = 'No existe el producto'
else
begin
	if(@TipCosto = 0)--PM
	begin
		select dbo.CostProm4(@RucE ,@Cd_Prod , GetDate(),'01',@ID_UMP) as Costo,
			   dbo.CostProm4(@RucE ,@Cd_Prod , GetDate() ,'02',@ID_UMP)as Costo_ME
		--select top 1 @Costo = abs(Cprom),  @Costo_ME = abs(Cprom_ME) from inventario where ruce = @RucE and Cd_Prod = @Cd_Prod order by FecMov desc, Cd_Inv desc
		if(@Costo is null or @Costo = '') set @Costo = 0
		if(@Costo_ME is null or @Costo_ME = '') set @Costo_ME = 0
		return
	end
	if(@TipCosto = 1) 
	begin
			--select top 1 @Costo = abs(CosUnt),  @Costo_ME = abs(Cprom_ME) from inventario where ruce = @RucE and Cd_Prod = @Cd_Prod and IC_ES = 'E' order by FecMov asc, Cd_Inv desc
		--select top 1 @Costo = abs(CosUnt),  @Costo_ME = abs(CosUnt_ME) from inventario where ruce = @RucE and Cd_Prod = @Cd_Prod and IC_ES = 'E' order by FecMov asc, Cd_Inv desc			 
		select dbo.CostUEPS2(@RucE ,@Cd_Prod,'01',@ID_UMP) as Costo,
			   dbo.CostUEPS2(@RucE ,@Cd_Prod,'02',@ID_UMP)as Costo_ME
		if(@Costo is null or @Costo = '') set @Costo = 0
		if(@Costo_ME is null or @Costo_ME = '') set @Costo_ME = 0
		return
	end	
	if(@TipCosto = 2) 
	begin
			--select top 1 @Costo = abs(CosUnt),  @Costo_ME = abs(Cprom_ME) from inventario where ruce = @RucE and Cd_Prod = @Cd_Prod and IC_ES = 'S' order by FecMov desc, Cd_Inv desc
		--select top 1 @Costo = abs(CosUnt),  @Costo_ME = abs(CosUnt_ME) from inventario where ruce = @RucE and Cd_Prod = @Cd_Prod and IC_ES = 'S' order by FecMov desc, Cd_Inv desc
		select dbo.CostPEPS2(@RucE ,@Cd_Prod,'01',@ID_UMP) as Costo,
			   dbo.CostPEPS2(@RucE ,@Cd_Prod,'02',@ID_UMP) as Costo_ME
		if(@Costo is null or @Costo = '') set @Costo = 0
		if(@Costo_ME is null or @Costo_ME = '') set @Costo_ME = 0
		return
	end
end

GO
