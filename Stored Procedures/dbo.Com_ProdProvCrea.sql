SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Com_ProdProvCrea]
@RucE nvarchar(11),
@Cd_Prv char(7),
@Cd_Prod char(7),
@ID_UMP int,
@CodigoAlt varchar(50),
@DescripAlt varchar(50),
@Obs varchar(200),
--@Estado bit,
@CA01 varchar(100),
@CA02 varchar(100),
@CA03 varchar(100),
@msj varchar(100) output
as
if exists (select * from ProdProv where RucE = @RucE and Cd_Prv = @Cd_Prv and Cd_Prod = @Cd_Prod and ID_UMP = @ID_UMP)
	set @msj = 'Ya existe Producto en el Proveedor'
else
	begin
		insert into ProdProv (RucE,Cd_Prv,Cd_Prod,ID_UMP,CodigoAlt,DescripAlt,Obs,Estado,CA01,CA02,CA03)
		     values(@RucE,@Cd_Prv,@Cd_Prod,@ID_UMP,@CodigoAlt,@DescripAlt,@Obs,1,@CA01,@CA02,@CA03)
		if @@rowcount <= 0
			set @msj = 'Producto no pudo ser registrado'	
	end
-- Leyenda --
-- JU : 2010-08-04 : <Creacion del procedimiento almacenado>
print @msj


GO
