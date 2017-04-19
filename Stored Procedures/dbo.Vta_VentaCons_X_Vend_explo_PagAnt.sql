SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Vta_VentaCons_X_Vend_explo_PagAnt]

@RucE nvarchar(11),
@FecD datetime,
@FecH datetime,
@Colum varchar(100),
@Dato varchar(100),
----------------------
@TamPag int, --Tamaño Pagina
@Ult_CdVta char(10),
@NroRegs int output, --Nro de Registros solo es consultado la primera vez
@NroPags int output, --Nro de Paginas solo es consultado la primera vez
@Max char(10) output,
@Min char(10) output,
----------------------
@msj varchar(100) output
as
	declare @Inter varchar(4000)
	set @Inter = 	'Venta as e inner join Vendedor as v on e.RucE = v.RucE and e.Cd_vdr = v.Cd_Aux 
			inner join Auxiliar as a on v.Cd_Aux = a.Cd_Aux and v.RucE = a.RucE 
			inner join Auxiliar as x on e.Cd_Cte = x.Cd_Aux and v.RucE = x.RucE'
	declare @Cond varchar(4000)
	declare @sql nvarchar(4000)

	set @Cond = 'e.RucE= '''+@RucE+''' and e.FecMov between '''+Convert(nvarchar,@FecD,103)+''' and '''+Convert(nvarchar,@FecH,103)+''' and e.Cd_Vta <'''+isnull(@Ult_CdVta,'')+''''
	if(@Colum = 'Cd_Vta') set @Cond = @Cond+ ' and e.Cd_Vta like '''+@Dato+''''
	else if(@Colum = 'RegCtb') set @Cond = @Cond+ ' and e.RegCtb like '''+@Dato+''''
	else if(@Colum = 'Cd_Aux') set @Cond =@Cond+ ' and a.Cd_Aux like '''+@Dato+''''
	else if(@Colum = 'NDoc') set @Cond = @Cond+' and a.NDoc like '''+@Dato+''''
	else if(@Colum = 'Nomb') set @Cond = @Cond+' and case(isnull(len(a.RSocial),0)) when 0 then a.ApPat +'' ''+ a.ApMat +'',''+ a.Nom else a.RSocial end  like '''+@Dato+''''
	else if(@Colum = 'FecED') set @Cond = @Cond+' and Convert(nvarchar,e.FecMov,103) like '''+@Dato+''''
	else if(@Colum = 'FecVD') set @Cond = @Cond+' and Convert(nvarchar,e.FecVD,103) like '''+@Dato+''''
	else if(@Colum = 'Cd_TD') set @Cond = @Cond+' and e.Cd_TD like '''+@Dato+''''
	else if(@Colum = 'NroDoc') set @Cond = @Cond+' and e.NroDoc like '''+@Dato+''''
	else if(@Colum = 'Cd_Cte') set @Cond = @Cond+' and e.Cd_Cte like '''+@Dato+''''
	else if(@Colum = 'NDoc_Clie') set @Cond = @Cond+' and x.NDoc like '''+@Dato+''''
	else if(@Colum = 'Clie') set @Cond = @Cond+' and case(isnull(len(x.RSocial),0)) when 0 then x.ApPat +'' ''+ x.ApMat +'',''+ x.Nom else x.RSocial end like '''+@Dato+''''
	else if(@Colum = 'BIM') set @Cond = @Cond+' and e.BIM like '''+@Dato+''''
	else if(@Colum = 'IGV') set @Cond =@Cond+ ' and e.IGV like '''+@Dato+''''
	else if(@Colum = 'Total') set @Cond = @Cond+' and e.Total like'''+@Dato+''''

	declare @Consulta varchar(8000)
	set @Consulta = 'select * from (select top '+Convert(nvarchar,@TamPag)+' e.Cd_Vta,e.RegCtb,a.Cd_Aux,a.NDoc,
			case(isnull(len(a.RSocial),0))
				when 0 then a.ApPat +'' ''+ a.ApMat +'',''+ a.Nom
					else a.RSocial end as Nomb,
			Convert(nvarchar,e.FecMov,103) as FecED,
			Convert(nvarchar,e.FecVD,103) as FecVD,
			e.Cd_TD, 
			e.NroDoc, 
			e.Cd_Cte,
			x.NDoc as NDoc_Clie,
			case(isnull(len(x.RSocial),0)) 
				when 0 then x.ApPat +'' ''+ x.ApMat +'',''+ x.Nom 
					else x.RSocial end as Clie,
			e.BIM,
			e.IGV, 
			e.Total from '+@Inter+' 
			where '+ @Cond+' order by e.Cd_Vta desc) as Venta order by Cd_Vta'

	exec (@Consulta)

	print @Consulta
	print @Cond
	print @Inter

	set @sql = 'select top 1 @RMax =Cd_Vta from '+@Inter+' where  '+@Cond+' order by Cd_Vta desc'
	exec sp_executesql @sql, N'@RMax char(10) output', @Max output
	print @sql
	set @sql = 'select @RMin = min(Cd_Vta) from(select top '+Convert(nvarchar,@TamPag)+' Cd_Vta from '+@Inter+' where  '+@Cond+' order by Cd_Vta desc) as Venta'
	exec sp_executesql @sql, N'@RMin char(10) output', @Min output
	print @sql
GO
