SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Vta_ServCons]
@RucE nvarchar(11),
@TipCons int,
@msj varchar(100) output
as

SET CONCAT_NULL_YIELDS_NULL OFF

/* TIPOS CONSULTA
0: General: select * from Tabla
1: ComboBox: select CodNom, Cd_Entidad from Tabla where Estado=1
2: Activos: select * from Tabla where Estado=1
3: Ayuda: select Cd_Ent,NroDoc,Nombre from Tabla
*/



/*if not exists (select top 1 * from Servicio where RucE=@RucE)
	set @msj = 'No se encontro Servicios'
else	*/
begin
	if(@TipCons=0)
	begin
		select a.RucE,a.Cd_Pro as Cd_Srv,b.Cd_GS,a.Nombre,a.Descrip,a.Cta1,a.Cta2,a.PrecioVta,a.IB_IncIGV,a.ValorVta,
		          case(a.IC_TipDcto)
			when 'I' then 'Importe'
			else 'Porcentual' end as IC_TipDcto,
		          a.Dcto,a.Estado  from Producto a, Servicio b where a.RucE=@RucE and a.RucE=b.RucE and a.Cd_Pro=b.Cd_Srv 
	end
	else if (@TipCons=1) 
	    begin
		 if (@RucE='20523031687')
			select a.CodCo+'  |  '+a.Nombre as CodNom,a.Cd_Pro as Cd_Srv,a.Nombre from Producto a, Servicio b where a.RucE=@RucE and a.RucE=b.RucE and a.Cd_Pro=b.Cd_Srv and a.Estado=1
		else select a.Cd_Pro+'  |  '+a.Nombre as CodNom,a.Cd_Pro as Cd_Srv,a.Nombre from Producto a, Servicio b where a.RucE=@RucE and a.RucE=b.RucE and a.Cd_Pro=b.Cd_Srv and a.Estado=1
	    end
	else if (@TipCons=2)
	    begin
		select a.RucE,a.Cd_Pro as Cd_Srv,b.Cd_GS,a.Nombre,a.Descrip,a.Cta1,a.Cta2,a.PrecioVta,a.IB_IncIGV,a.ValorVta,
		          case(a.IC_TipDcto)
			when 'I' then 'Importe'
			else 'Porcentual' end as IC_TipDcto,
		          a.Dcto,a.Estado  from Producto a, Servicio b where a.RucE=@RucE and a.RucE=b.RucE and a.Cd_Pro=b.Cd_Srv and a.Estado=1
	    end
	else if (@TipCons=3)
	    begin
		 if (@RucE='20523031687')
			select a.Cd_Pro as Cd_Srv,a.CodCo as Cd_Pro,a.Nombre from Producto a, Servicio b where a.RucE=@RucE and a.RucE=b.RucE and a.Cd_Pro=b.Cd_Srv and a.Estado=1
		else select a.Cd_Pro as Cd_Srv,a.Cd_Pro,a.Nombre from Producto a, Servicio b where a.RucE=@RucE and a.RucE=b.RucE and a.Cd_Pro=b.Cd_Srv and a.Estado=1

	    endend
print @msj
GO
