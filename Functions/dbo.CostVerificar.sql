SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[CostVerificar](@RucE nvarchar(11),@Cd_Vta nvarchar(10))
returns char(1) AS
begin 
	declare @cost varchar(1)
	declare @cost_ME varchar(1)
	declare @resul char(1)
	--declare @ItemVta int = (select count(Nro_RegVdt) from ventadet where ruce=@RucE and cd_vta=@Cd_Vta and Cd_Prod is not null)
	--declare @ItemInv int = (select  case when max(item) is null then 0 else max(item)end from inventario where ruce=@RucE and cd_vta=@Cd_Vta)
	declare @CantInv int = (select count(*) from inventario v where ruce=@RucE and cd_vta=@Cd_Vta)
	declare @CantVta int = (select count(*) from ventadet v where ruce=@RucE and cd_vta=@Cd_Vta and Cd_Prod is not null)
	
	if((@CantInv = 0 and @CantVta != 0) or (@CantInv = 0 and @CantVta = 0))
		set @resul = '2'
	else
		begin
			if(@CantInv=@CantVta)
				begin
					select 
					   @cost = ( case when round((abs(sum(inv.Total))),2) = round((abs(Max(case when vdt.Costo is null then 0 else vdt.Costo end))),2)then 'C' else 'F' end)-- as Resul
					   ,@cost_ME = ( case when round((abs(sum(inv.Total_ME))),2) = round((abs(Max(case when vdt.Costo_ME is null then 0 else vdt.Costo_ME end))),2)then 'C' else 'F' end)-- as Resul_ME
						from inventario inv
						inner join venta v on inv.ruce=v.ruce and inv.Cd_Vta = v.Cd_Vta
						inner join ventadet vdt on vdt.ruce=v.ruce and vdt.Cd_Vta = v.Cd_vta and vdt.Nro_regVdt=inv.Item
						where vdt.ruce=@RucE and vdt.Cd_Vta=@Cd_Vta 
						group by inv.item, vdt.Nro_regVdt,inv.Cd_Prod,inv.Cd_Vta --,inv.CamMda, --, inv.RegCtb order by inv.RegCtb
						set @Cost = @Cost
						set @cost_ME = @Cost_ME
						if(@Cost='C' and @Cost_ME='C')begin set @resul='1' end
						if(@Cost='F' and @Cost_ME='F')begin set @resul='0' end
						if(@Cost='C' and @Cost_ME='F')begin set @resul='0' end
						if(@Cost='F' and @Cost_ME='C')begin set @resul='0' end
			  end
			  else 
				set @resul='3'
		end
	return @resul
end

--LEYENDA
--TODO Falta verificar con movimientos complejos
/*
0 Rojo no cuadra
1 Blanco cuadra
2 Amarillo sin movimiento de inventario
3 Azul Movimiento inconpleto de inventario
*/
-- CE: 08/08/2012 - venta - inv relacionada si cuadra,no cuadra, imcompleta, no se relacionan
GO
