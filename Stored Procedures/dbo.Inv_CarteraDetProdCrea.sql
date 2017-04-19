SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_CarteraDetProdCrea]
@RucE nvarchar(11),
@Cd_Ct char(3),
@Cd_Prod char(7),
@msj varchar(100) output
as
if exists (select * from CarteraProdDet_P where RucE=@RucE and Cd_Ct=@Cd_Ct and Cd_Prod=@Cd_Prod)
	set @msj = 'Cartera  ' + @Cd_Ct + ' contiene el producto '+@Cd_Prod
else
begin
	insert into CarteraProdDet_P(RucE,Cd_Ct,Cd_Prod,Estado)
		   Values(@RucE,@Cd_Ct,@Cd_Prod,1)
	
	if @@rowcount <= 0
	set @msj = 'Detalle de Cartera de Productos no pudo ser registrado'	
end
print @msj
-------------
--J : 25-03-2010 <creado>
GO
