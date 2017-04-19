SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Com_Proveedor2Cons_explo_PagAnt]
@RucE nvarchar(11),
@TamPag int,
@Ult_Prov nvarchar(7),
@Max nvarchar(7) output,
@Min nvarchar(7) output,
@msj varchar(100) output
as
		/*select top 100 
			a.RucE,a.Cd_Aux,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
		        a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,a.Cd_TA,c.Nombre as NomTipAux,a.Estado
                from Auxiliar a
		        left join TipDocIdn b on a.Cd_TDI=b.Cd_TDI
	                left join TipAux c on a.Cd_TA=c.Cd_TA
		        where 	
			a.RucE=@RucE and a.Cd_Aux < @Ult_Aux
		order by 
			a.RucE desc, a.Cd_Aux desc
		
		select @Min = 
			    min(Cd_Aux)from (select top 100 Cd_Aux  from Auxiliar 
			    where RucE=@RucE and Cd_Aux < @Ult_Aux 
			    order by RucE desc, Cd_Aux desc) as CdAuxX
		set @Max = (select top 1 Cd_Aux  from Auxiliar 
			    where RucE=@RucE and Cd_Aux < @Ult_Aux 
			    order by RucE desc, Cd_Aux desc)*/


		/*	declare @RucE nvarchar(11)
			declare @TamPag int
			declare @Max nvarchar(10)
			declare @Min nvarchar(10)
			declare @Ult_Aux nvarchar(10)
			set @TamPag = 5
			set @RucE = '11111111111'
			set @Max = 'VND0004'
			set @Min = 'AUX0001'
			set @Ult_Aux='VND0004'
		*/
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---inicio --> consulta proveedores pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	declare @Inter varchar(1000)
	set @Inter = 'Proveedor2 a
			left join TipDocIdn b on a.Cd_TDI=b.Cd_TDI
			left join Pais c on a.Cd_Pais=c.Cd_Pais'
	declare @sql nvarchar(1000)
	declare @Cond varchar(1000)
	set @Cond = 'a.RucE= '''+@RucE+'''and a.Cd_Prv<'''+isnull(@Ult_Prov,'')+''''	
	
	declare @Consulta nvarchar(4000)
	set @Consulta = 
	'select *from (select top '+Convert(nvarchar,@TamPag)+' a.RucE,a.Cd_Prv,a.Cd_TDI,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,a.Cd_Pais,c.Nombre,a.CodPost,a.Ubigeo,
	a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.Obs,a.CtaCtb,a.CA01,a.CA02,a.CA03,a.CA04,a.CA05,a.CA06,a.CA07,a.CA08,a.CA09,a.CA10,a.Estado from '+
	@Inter+' where '+
	@Cond+'order by a.Cd_Prv asc) as Proveedor order by Cd_Prv'
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> consulta auxiliares pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------		
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---inicio --> obtenemos el registro mÃƒÂ¡ximo & mÃƒÂ­nimo de auxiliares //ordenado por : ApPat,ApMat,RSocial
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	set @sql = 'select top 1 @RMax =Cd_Prv from '+@Inter+' where  '+@Cond+' order by Cd_Prv/*ApPat,ApMat,RSocial*/ desc'--ver orden por ApPat,ApMat,RSocial
	exec sp_executesql @sql, N'@RMax nvarchar(7) output', @Max output
	print @sql
	set @sql = 'select @RMin = min(Cd_Prv) from(select top '+Convert(nvarchar,@TamPag)+'Cd_Prv from '+@Inter+' where  '+@Cond+' order by Cd_Prv/*ApPat,ApMat,RSocial*/ desc) as Proveedor'
	exec sp_executesql @sql, N'@RMin nvarchar(7) output', @Min output
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> obtenemos el registro mÃƒÂ¡ximo & mÃƒÂ­nimo de proveedores //ordenado por : ApPat,ApMat,RSocial
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Exec (@Consulta) -- Ejecutamos la consulta 
			
	print 'Maximo:' + @Max
	print 'Minimo:' + @Min
	print @sql
	
print @msj

----------------------LEYENDA----------------------
--J : Mar 12-10-2010 <creacion>
----------------------PRUEBA------------------------
--select * from Proveedor2 Where RucE='11111111111'
--Declare @Max nvarchar(10),@Min nvarchar(10)
--exec dbo.Com_Proveedor2Cons_explo_PagAnt '11111111111',50,'PRV0005',@Max out,@Min out,null
--exec dbo.Com_Proveedor2Cons_explo_PagAnt '11111111111',50,'PRV0005','','',null





GO
