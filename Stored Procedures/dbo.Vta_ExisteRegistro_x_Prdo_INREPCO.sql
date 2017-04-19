SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Vta_ExisteRegistro_x_Prdo_INREPCO]
@RucE nvarchar(11),
@Ejer nvarchar(4),
@Prdo nvarchar(2),
@Cd_Clt varchar(15),
@Cd_TD nvarchar(2),
--@NroDoc nvarchar(15),
--@Cd_Sr nvarchar(4),
@FecMov smalldatetime,

@msj varchar(100) output
as 

if exists (select * from Venta where RucE = @RucE and Eje = @Ejer and Prdo = @Prdo 
			and FecMov = @FecMov and Cd_Clt = @Cd_Clt and Cd_TD = @Cd_TD)
begin
	set @msj = 'Ya existe una Venta para dicho mes y cliente.'
end
	
GO
