SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Ctb_AuxiliarCons_PagAnt]
@RucE nvarchar(11),
@TipCons int,
@TamPag int,
@Ult_Aux nvarchar(7),
@Max nvarchar(7) output,
@Min nvarchar(7) output,
@msj varchar(100) output
as
begin
	if(@TipCons=0)
	    begin
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
	---inicio --> consulta auxiliares pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	declare @Inter varchar(1000)
	set @Inter = 'Auxiliar a
			left join TipDocIdn b on a.Cd_TDI=b.Cd_TDI
		        left join TipAux c on a.Cd_TA=c.Cd_TA'
	declare @sql nvarchar(1000)
	declare @Cond varchar(1000)
	set @Cond = 'a.RucE= '''+@RucE+'''and a.Cd_Aux<'''+isnull(@Ult_Aux,'')+''''	
	
	declare @Consulta nvarchar(4000)
	set @Consulta = 
	'select *from(select top '+Convert(nvarchar,@TamPag)+' a.RucE,a.Cd_Aux,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,a.Cd_Pais,a.CodPost,a.Ubigeo,
	a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,a.Cd_TA,c.Nombre as NomTipAux,a.Estado from '+@Inter+' where '+@Cond+'order by a.Cd_Aux desc) as Auxiliar order by Cd_Aux'
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> consulta auxiliares pagina anterior
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---inicio --> obtenemos el registro mÃ¡ximo & mÃ­nimo de auxiliares //ordenado por : ApPat,ApMat,RSocial
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	set @sql = 'select top 1 @RMax =Cd_Aux from '+@Inter+' where  '+@Cond+' order by Cd_Aux/*ApPat,ApMat,RSocial*/ desc'--ver orden por ApPat,ApMat,RSocial
	exec sp_executesql @sql, N'@RMax nvarchar(7) output', @Max output

	set @sql = 'select @RMin = min(Cd_Aux) from(select top '+Convert(nvarchar,@TamPag)+'Cd_Aux from '+@Inter+' where  '+@Cond+' order by Cd_Aux/*ApPat,ApMat,RSocial*/ desc) as Auxiliar'
	exec sp_executesql @sql, N'@RMin nvarchar(7) output', @Min output
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	---final --> obtenemos el registro mÃ¡ximo & mÃ­nimo de auxiliares //ordenado por : ApPat,ApMat,RSocial
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Exec (@Consulta) -- Ejecutamos la consulta 
			
	--print @Max
	--print @Min
	--print @sql

	    end
	else if (@TipCons=1) 
	    begin
		select case(isnull(len(a.RSocial),0))
	                     when 0 then a.NDoc+'  |  '+a.ApPat+' '+a.ApMat+' '+a.Nom
		       else a.NDoc+'  |  '+a.RSocial end as CodNom,
		       a.Cd_Aux as Cd_Aux
		       from Auxiliar a, TipDocIdn b where a.RucE=@RucE and a.Cd_TDI=b.Cd_TDI and a.Estado=1
	    end
	else if (@TipCons=2)
	    begin
		select a.RucE,a.Cd_Aux as Cd_Cte,b.NCorto as NCortoTDI,a.NDoc,a.RSocial,a.ApPat,a.ApMat,a.Nom,
		          a.Cd_Pais,a.CodPost,a.Ubigeo,a.Direc,a.Telf1,a.Telf2,a.Fax,a.Correo,a.PWeb,a.Estado
                       from Auxiliar a, TipDocIdn b where a.RucE=@RucE and a.Cd_TDI=b.Cd_TDI and a.Estado=1
	    end
	else if (@TipCons=3)
	   begin
	   	select a.Cd_Aux,
		       a.NDoc,
		       case(isnull(len(a.RSocial),0))
	                     when 0 then a.ApPat+' '+a.ApMat+' '+a.Nom
		       else a.RSocial end as Nombre
		       from Auxiliar a, TipDocIdn b where a.RucE=@RucE and a.Cd_TDI=b.Cd_TDI
	   end
end
print @msj
---
--J -> Modificado 03-05-2010 -> PAGINACION

GO
