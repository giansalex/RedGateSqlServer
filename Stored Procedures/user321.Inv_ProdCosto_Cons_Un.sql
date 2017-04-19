SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE procedure [user321].[Inv_ProdCosto_Cons_Un]
@RucE nvarchar(11),
@Cd_Prod char(7),
@TipCosto int,
@Costo float output,
--------------------------------------
@msj varchar(100) output

as

if not exists (select Cd_Prod from producto2 where Cd_Prod = @Cd_Prod)
	set @msj = 'No existe el producto'
else
begin
	if(@TipCosto = 1)
	begin
		select top 1 @Costo = abs(Cprom) from inventario where ruce = @RucE and Cd_Prod = @Cd_Prod order by FecMov desc, Cd_Inv desc
		if(@Costo is null or @Costo = '') set @Costo = 0
		return
	end
	if(@TipCosto = 2)
	begin
		select top 1 @Costo = abs(CosUnt) from inventario where ruce = @RucE and Cd_Prod = @Cd_Prod and IC_ES = 'E' order by FecMov desc, Cd_Inv desc
		if(@Costo is null or @Costo = '') set @Costo = 0
		return
	end
end
GO
