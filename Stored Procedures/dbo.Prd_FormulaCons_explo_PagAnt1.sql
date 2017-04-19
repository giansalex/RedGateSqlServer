SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Prd_FormulaCons_explo_PagAnt1]
@RucE nvarchar(11),
@TamPag int,
@Ult_NroFor char(10),
@Max char(10) output,
@Min char(10) output,
@msj varchar(100) output
as
	declare @sql nvarchar(1000)
	declare @Cond varchar(1000)
	set @Cond = 'f.RucE = '''+@RucE+''' and f.Cd_Prod+right(''00''+convert(varchar, f.ID_UMP), 3) < '''+convert(nvarchar,isnull(@Ult_NroFor,''))+''''	
	declare @Consulta nvarchar(4000)
	set @Consulta = 
	'select *from (select top '+Convert(nvarchar,@TamPag)+ ' p.Cd_Prod, p.Nombre1, p.Descrip, u.ID_UMP, u.DescripAlt, count(*) as CantForm from Formula as f 
	inner join Producto2 as p on p.RucE = f.RucE and p.Cd_Prod = f.Cd_Prod
	inner join Prod_UM as u on u.RucE = f.RucE and u.Cd_Prod = f.Cd_Prod and u.ID_UMP = f.ID_UMP
	where '+@Cond+'
	group by p.Cd_Prod, p.Nombre1, p.Descrip, u.ID_UMP, u.DescripAlt
	order by p.Cd_Prod desc, u.Id_UMP desc) as Formulacion order by Cd_Prod , Id_UMP '
	
	exec (@Consulta) 
	
	set @sql = 'select @RMax = max(f.Cd_Prod+right(''00''+convert(varchar, f.ID_UMP), 3)) from Formula as f where ' + @Cond+' group by f.Cd_Prod, f.ID_UMP order by Cd_Prod, Id_UMP '
	exec sp_executesql @sql, N'@RMax nvarchar(10) output', @Max output
	
	set @sql = 'select @RMin = min(Cd_Pr) from(select top '+Convert(nvarchar,@TamPag)+ ' f.Cd_Prod+right(''00''+convert(varchar, f.ID_UMP), 3) as Cd_Pr from Formula as f where ' + @Cond+' group by f.Cd_Prod , f.ID_UMP order by f.Cd_Prod desc, f.Id_UMP desc) as Formulacion'
	print  @sql
	exec sp_executesql @sql, N'@RMin nvarchar(10) output', @Min output

----------------------LEYENDA----------------------
--FL : Mar 10-02-2011 <creacion del procedimiento almacenado>
GO
