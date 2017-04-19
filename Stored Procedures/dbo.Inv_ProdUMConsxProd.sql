SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Inv_ProdUMConsxProd]
@RucE nvarchar(11),
@Cd_Prod char(7),
@TipCons int,
@msj varchar(100) output
as
--if not exists (select * from Prod_UM where RucE=@RucE and Cd_Prod=@Cd_Prod)
--	set @msj = 'No existe Unidad de Medida para el Producto'+' '+@Cd_Prod
--else	
--begin
if (@TipCons=0)
	select ID_UMP,UM.Cd_UM,descripAlt,Factor,Nombre,NCorto,Estado  from Prod_UM as PUM inner join UnidadMedida as UM on PUM.Cd_UM = UM.Cd_UM and UM.Estado= 1 and Cd_Prod=@Cd_Prod and RucE=@RucE
else if (@TipCons=1)
	select  convert(varchar(4),proum.ID_UMP)+'  |  '+proum.DescripAlt as CodNom,proum.ID_UMP from Prod_UM proum,Producto2 pro,UnidadMedida um
	Where proum.RucE=@RucE and proum.RucE=pro.RucE and pro.Cd_Prod=@Cd_Prod
	and proum.Cd_UM = um.Cd_UM and proum.Cd_Prod=pro.Cd_Prod order by proum.ID_UMP
else if (@TipCons=2)
	select  proum.Id_UMP,proum.Cd_Prod,proum.Cd_UM,proum.DescripAlt from Prod_UM proum,Producto2 pro,UnidadMedida um
	Where proum.RucE=@RucE and proum.RucE=pro.RucE and pro.Cd_Prod=@Cd_Prod
	and proum.Cd_UM = um.Cd_UM and proum.Cd_Prod=pro.Cd_Prod order by proum.ID_UMP
else if (@TipCons =3)
	begin
		declare @check bit
		set @check=0

		select @check as Sel,proum.Id_UMP as Item,proum.Cd_Prod as CodPro,proum.Cd_UM as CodUM,proum.DescripAlt as Descrip
			from Prod_UM proum left join Producto2 pro On proum.RucE=pro.RucE and proum.Cd_Prod=pro.Cd_Prod
				left join UnidadMedida um On proum.Cd_UM = um.Cd_UM
				where proum.RucE=@RucE and pro.Cd_Prod=@Cd_Prod
	end
--end
print @msj
-- Leyenda --
-- PP : 2010-02-26 : <Creacion del procedimiento almacenado>
-- PP : 2010-03-11 13:54:28 : <Modificacion del procedimiento almacenado agrege  el TipCons = 3 :@>
GO
