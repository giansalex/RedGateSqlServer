SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_Producto2_ListUM]
@RucE nvarchar(11),
@Cd_Prod char(7),
@msj varchar(100) output
as

	declare @check bit
	set @check=0

	select 
	@check as Sel,proum.Id_UMP as Item,proum.Cd_Prod as CodPro,proum.Cd_UM as CodUM,proum.DescripAlt as Descrip
	from 
	Prod_UM proum 
	left join Producto2 pro 
	On proum.RucE=pro.RucE and proum.Cd_Prod=pro.Cd_Prod
	left join UnidadMedida um 
	On proum.Cd_UM = um.Cd_UM
	where 
	proum.RucE=@RucE and pro.Cd_Prod=@Cd_Prod and pro.Estado =1

-- Leyeda --
--JE : 04/03/2010 <Creacion del procedimiento almacenado>
GO
