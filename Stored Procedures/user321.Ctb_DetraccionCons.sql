SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [user321].[Ctb_DetraccionCons]
@RucE nvarchar(11),
@Cd_Prv char(7),
@TipCons int,
@msj varchar(100) output
as
begin
	if(@TipCons=0)
	begin
		select a.Cd_Prv,a.Cd_CDtr,b.Descrip +' | '+
		case when Isnull(b.Cd_Prod,'')='' then s2.Nombre else p2.Nombre1 end as Descrip /*b.Descrip*/,a.IB_Ctb
		from CptoDetxProv a inner join ConceptosDetrac b
		on a.RucE=b.RucE and a.Cd_CDtr=b.Cd_CDtr 
		left join Producto2 p2 on p2.RucE=b.RucE and p2.Cd_Prod=b.Cd_Prod
		left join Servicio2 s2 on s2.RucE=b.RucE and s2.Cd_Srv=b.Cd_Srv
		where a.RucE=@RucE and a.Cd_Prv=@Cd_prv order by a.Cd_CDtr
	end
	else if(@TipCons=1)
	begin
		select Cd_CDtr+' | '+ Descrip,Cd_CDtr from ConceptosDetrac where RucE=@RucE
	end
	else if(@TipCons=3)
	begin
		select cd.Cd_CDtr, cd.Cd_CDtr, cd.Descrip +' | '+
		case when Isnull(cd.Cd_Prod,'')='' then s2.Nombre else p2.Nombre1 end as Descrip 
		from 
			ConceptosDetrac cd left join Producto2 p2 on p2.RucE=cd.RucE and p2.Cd_Prod=cd.Cd_Prod
			left join Servicio2 s2 on s2.RucE=cd.RucE and s2.Cd_Srv=cd.Cd_Srv
		where cd.RucE=@RucE
	end
end
print @msj
-- Leyenda --
-- JJ : 2011-02-09 : <Creacion del procedimiento almacenado>


GO
