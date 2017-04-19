SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [user321].[Inv_Seriales_Cons_SerialCorrecto]
@RucE nvarchar(11),
@Cd_Prod char(7),
@Serial varchar(100),
@msj varchar(100) output
as
if not exists (select * from SerialMov sm 
left join inventario inv on (sm.RucE=inv.RucE and sm.Cd_Inv=inv.Cd_Inv) 
left join compra com on (sm.RucE=com.RucE and sm.Cd_Com=com.Cd_Com) 
where sm.RucE=@ruce and sm.Cd_Prod=@Cd_Prod and sm.Serial=@Serial and (inv.IC_ES='E' or com.Cd_Com is not null))
	begin
	Set @msj = 'Uno o mas de los productos no tienen entrada o serial'
	print 'Uno o mas de los productos no tienen entrada o serial'
	end
	else
	begin
	print 'correcto'
	end
--leyenda
-- armando 26/06/2012 creacion
--AC modificado 19/10/2012

--user321.Inv_Seriales_Cons_SerialCorrecto '11111111111','pd00012','c11',null
GO
