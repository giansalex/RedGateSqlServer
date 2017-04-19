SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Prd_FormulaCons_explo_PagSig1]
@RucE nvarchar(11),
@TamPag int,
@Ult_NroFor char(10),
@NroRegs int output,
@NroPags int output,
@Max char(10) output,
@Min char(10) output,
@msj varchar(100) output
as
	declare @sql nvarchar(1000)
	declare @Cond varchar(1000)
	set @Cond = 'f.RucE = '''+@RucE+''' and f.Cd_Prod+right(''00''+convert(varchar, f.ID_UMP), 3) > '''+convert(nvarchar,isnull(@Ult_NroFor,''))+''''	
	declare @Consulta nvarchar(4000)
	set @Consulta = 
	'select top '+Convert(nvarchar,@TamPag)+ ' p.Cd_Prod, p.Nombre1, p.Descrip, u.ID_UMP, u.DescripAlt, count(*) as CantForm from Formula as f 
	inner join Producto2 as p on p.RucE = f.RucE and p.Cd_Prod = f.Cd_Prod
	inner join Prod_UM as u on u.RucE = f.RucE and u.Cd_Prod = f.Cd_Prod and u.ID_UMP = f.ID_UMP
	where '+@Cond+'
	group by p.Cd_Prod, p.Nombre1, p.Descrip, u.ID_UMP, u.DescripAlt
	order by p.Cd_Prod, u.Id_UMP'
	
	exec (@Consulta) 
	if (@Ult_NroFor='' or @Ult_NroFor is null)
	begin
		set @sql= 'select @Regs = count(*) from (select f.Cd_Prod, f.ID_UMP from Formula as f where ' + @Cond+' group by f.Cd_Prod, f.ID_UMP) as Formulacion'
		exec sp_executesql @sql, N'@Regs int output', @NroRegs output
		select @NroPags =  @NroRegs/@TamPag + case when  @NroRegs%@TamPag=0 then 0 else 1 end
	end

	set @sql = 'select @RMax = max(Cd_Pr) from(select top '+Convert(nvarchar,@TamPag)+ ' f.Cd_Prod+right(''00''+convert(varchar, f.ID_UMP), 3) as Cd_Pr from Formula as f where ' + @Cond+' group by f.Cd_Prod, f.ID_UMP) as Formulacion'
	exec sp_executesql @sql, N'@RMax nvarchar(10) output', @Max output

	set @sql = 'select top 1 @RMin = f.Cd_Prod+right(''00''+convert(varchar, f.ID_UMP), 3) from Formula as f where ' + @Cond + ' group by f.Cd_Prod, f.ID_UMP'
	exec sp_executesql @sql, N'@RMin nvarchar(10) output', @Min output	
	
----------------------LEYENDA----------------------
--FL : Mar 10-02-2011 <creacion del procedimiento almacenado>
GO
